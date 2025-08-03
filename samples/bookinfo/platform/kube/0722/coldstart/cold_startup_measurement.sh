echo "=== Cold Startup Time Measurement (이미지 캐시 제거) ==="

# 함수: 모든 이미지 캐시 제거
cleanup_image_cache() {
    echo "Cleaning up image cache..."
    
    # Minikube 내부 Docker 이미지 삭제
    minikube ssh -- docker rmi -f $(minikube ssh -- docker images -q) 2>/dev/null || true
    
    # 시스템 정리
    minikube ssh -- docker system prune -af
    
    # 확인
    echo "Remaining images:"
    minikube ssh -- docker images
}

# 함수: 특정 서비스 이미지만 제거
cleanup_bookinfo_images() {
    echo "Removing Bookinfo images from cache..."
    
    IMAGES=(
        "istio/examples-bookinfo-productpage-v1:1.20.3"
        "istio/examples-bookinfo-details-v1:1.20.3" 
        "istio/examples-bookinfo-reviews-v1:1.20.3"
        "istio/examples-bookinfo-ratings-v1:1.20.3"
    )
    
    for image in "${IMAGES[@]}"; do
        echo "Removing $image..."
        minikube ssh -- docker rmi -f "$image" 2>/dev/null || true
    done
    
    echo "Bookinfo images removed from cache"
}

# 함수: Cold startup 측정
measure_cold_startup() {
    local service=$1
    local image=$2
    
    echo "Measuring cold startup for $service..."
    
    # 1. 이미지가 캐시에 없는지 확인
    if minikube ssh -- docker images | grep -q "$service"; then
        echo "WARNING: $service image still in cache!"
        return 1
    fi
    
    # 2. 측정 시작 시간 기록
    START_TIME=$(date +%s%3N)
    echo "COLD_START_BEGIN: $service at ${START_TIME}ms"
    
    # 3. 상세 측정용 파드 배포
    cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${service}-cold-test
  namespace: bookinfo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${service}
      test: cold-startup
  template:
    metadata:
      labels:
        app: ${service}
        test: cold-startup
    spec:
      containers:
      - name: ${service}
        image: ${image}
        imagePullPolicy: Always  # 강제로 이미지 다운로드
        ports:
        - containerPort: 9080
        command:
        - sh
        - -c
        - |
          # 상세 단계별 측정
          echo "[COLD_TIMING] CONTAINER_START: \$(date +%s%3N)"
          echo "[COLD_TIMING] IMAGE_AVAILABLE: \$(date +%s%3N)"
          
          # 환경 설정
          export PATH=/opt/microservices:\$PATH
          echo "[COLD_TIMING] ENV_SETUP: \$(date +%s%3N)"
          
          # 서비스별 시작 명령어
          case "${service}" in
            productpage)
              cd /opt/microservices
              echo "[COLD_TIMING] APP_INIT_START: \$(date +%s%3N)"
              python productpage.py 9080
              ;;
            details)
              cd /opt/microservices  
              echo "[COLD_TIMING] APP_INIT_START: \$(date +%s%3N)"
              ruby details.rb 9080
              ;;
            ratings)
              cd /opt/microservices
              echo "[COLD_TIMING] APP_INIT_START: \$(date +%s%3N)"
              node ratings.js 9080
              ;;
            reviews)
              echo "[COLD_TIMING] APP_INIT_START: \$(date +%s%3N)"
              /opt/ol/wlp/bin/server run defaultServer
              ;;
          esac
        readinessProbe:
          httpGet:
            path: /health
            port: 9080
          initialDelaySeconds: 1
          periodSeconds: 1
EOF

    # 4. 파드 상태 모니터링
    echo "Monitoring pod startup progress..."
    
    # 파드 생성 대기
    kubectl wait --for=condition=ready pod -l app=${service},test=cold-startup -n bookinfo --timeout=300s
    
    # 5. 최종 시간 기록
    END_TIME=$(date +%s%3N)
    TOTAL_TIME=$((END_TIME - START_TIME))
    
    echo "COLD_START_COMPLETE: $service at ${END_TIME}ms"
    echo "TOTAL_COLD_STARTUP: $service took ${TOTAL_TIME}ms"
    
    # 6. 상세 로그 수집
    kubectl logs -n bookinfo -l app=${service},test=cold-startup | grep COLD_TIMING > ${service}_cold_timing.log
    
    echo "Cold startup measurementt for $service completed"
    echo "Detailed timing saved to: ${service}_cold_timing.log"
}

# 메인 실행
main() {
    echo "Starting cold startup measurement..."
    
    # 네임스페이스 준비
    kubectl delete namespace bookinfo --ignore-not-found=true
    kubectl create namespace bookinfo
    kubectl label namespace bookinfo istio-injection=enabled
    
    # 모든 이미지 캐시 제거 (선택사항)
    read -p "Remove ALL Docker images? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cleanup_image_cache
    else
        cleanup_bookinfo_images
    fi
    
    echo "Waiting 10 seconds for cleanup to complete..."
    sleep 10
    
    # 각 서비스별 순차 측정
    SERVICES=(
        "productpage:docker.io/istio/examples-bookinfo-productpage-v1:1.16.2"
        "details:docker.io/istio/examples-bookinfo-details-v1:1.16.2"
        "reviews:docker.io/istio/examples-bookinfo-reviews-v1:1.16.2"
        "ratings:docker.io/istio/examples-bookinfo-ratings-v1:1.16.2"
    )
    
    for service_info in "${SERVICES[@]}"; do
        service=$(echo $service_info | cut -d: -f1)
        image=$(echo $service_info | cut -d: -f2-)
        
        echo ""
        echo "=== Measuring $service ==="
        measure_cold_startup "$service" "$image"
        
        # 측정 간 간격
        sleep 5
        
        # 다음 측정을 위해 현재 파드 제거
        kubectl delete deployment ${service}-cold-test -n bookinfo
        sleep 5
    done
    
    # 최종 분석
    analyze_cold_startup_results
}

# 결과 분석 함수
analyze_cold_startup_results() {
    echo ""
    echo "=== COLD STARTUP ANALYSIS ==="
    
    # 각 서비스의 상세 타이밍 분석
    for service in productpage details reviews ratings; do
        if [ -f "${service}_cold_timing.log" ]; then
            echo ""
            echo "Service: $service"
            echo "Detailed timing breakdown:"
            
            # 타임스탬프 추출 및 분석
            while read -r line; do
                if [[ $line =~ \[COLD_TIMING\]\ ([^:]+):\ ([0-9]+) ]]; then
                    stage="${BASH_REMATCH[1]}"
                    timestamp="${BASH_REMATCH[2]}"
                    echo "  $stage: ${timestamp}ms"
                fi
            done < "${service}_cold_timing.log"
        fi
    done
    
    # JSON 형태로 결과 저장
    python3 << 'EOF'
import json
import re
import glob

results = {}
for log_file in glob.glob("*_cold_timing.log"):
    service = log_file.replace("_cold_timing.log", "")
    results[service] = {}
    
    try:
        with open(log_file, 'r') as f:
            for line in f:
                match = re.search(r'\[COLD_TIMING\] ([^:]+): (\d+)', line)
                if match:
                    stage = match.group(1)
                    timestamp = int(match.group(2))
                    results[service][stage] = timestamp
    except FileNotFoundError:
        pass

# 시간 차이 계산
for service, timings in results.items():
    if len(timings) >= 2:
        timestamps = list(timings.values())
        timestamps.sort()
        
        print(f"\n{service} Cold Startup Breakdown:")
        prev_time = timestamps[0]
        
        for stage, timestamp in sorted(timings.items(), key=lambda x: x[1]):
            duration = timestamp - prev_time if prev_time else 0
            print(f"  {stage}: {timestamp}ms (+{duration}ms)")
            prev_time = timestamp

# 결과를 JSON 파일로 저장
with open('cold_startup_results.json', 'w') as f:
    json.dump(results, f, indent=2)

print("\nResults saved to: cold_startup_results.json")
EOF
}

# 스크립트 실행
main "$@"
