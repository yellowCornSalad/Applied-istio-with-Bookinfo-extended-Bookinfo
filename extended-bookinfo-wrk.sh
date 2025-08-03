#!/bin/bash
# Extended Bookinfo 서비스들에 wrk 트래픽 생성 스크립트

MINIKUBE_IP=$(minikube ip -p istiotest)
echo "🚀 Extended Bookinfo 서비스들에 wrk 트래픽을 생성합니다..."
echo "📍 Minikube IP: $MINIKUBE_IP"

# 트래픽 생성 함수
generate_traffic() {
    local service_name=$1
    local port=$2
    local url="http://$MINIKUBE_IP:$port"
    
    echo "📊 $service_name에 트래픽 생성 중... ($url)"
    wrk -t4 -c50 -d1h "$url" &
    sleep 2
}

# 모든 서비스에 트래픽 생성
echo "🔥 모든 서비스에 동시에 트래픽 생성 시작..."

generate_traffic "Library Portal" "30081"
generate_traffic "User Service" "30082"
generate_traffic "Catalog Service" "30083"
generate_traffic "Inventory Service" "30084"
generate_traffic "Order Service" "30085"
generate_traffic "Payment Service" "30086"
generate_traffic "Notification Service" "30087"
generate_traffic "Search Service" "30088"
generate_traffic "Recommendation Service" "30089"
generate_traffic "Analytics Service" "30090"
generate_traffic "Shipping Service" "30091"

echo "⏳ 30초 동안 트래픽이 생성됩니다..."
echo "📈 Kiali에서 Traffic Graph를 확인해보세요!"
echo "🌐 Kiali 접속: http://localhost:20001"

# 모든 백그라운드 프로세스 완료 대기
wait
echo "✅ 모든 트래픽 생성 완료!" 
