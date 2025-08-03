# Istio 1.23.0 Extended Bookinfo 프로젝트

## 📋 프로젝트 개요

이 프로젝트는 Istio 1.23.0을 사용하여 Extended Bookinfo 애플리케이션을 Kubernetes 환경에서 실행하는 예제입니다.

## 🚀 주요 기능

- **Istio Service Mesh**: 마이크로서비스 간 통신 관리
- **MTLS 보안**: 서비스 간 상호 TLS 인증
- **모니터링**: Kiali, Grafana, Prometheus, Jaeger
- **트래픽 관리**: VirtualService, Gateway, DestinationRule
- **확장된 서비스**: 11개의 마이크로서비스

## 📁 프로젝트 구조

```
istio-1.23.0/
├── bin/                          # Istioctl 바이너리
├── manifests/                     # Istio 매니페스트
├── samples/                      # Istio 샘플
├── train-ticket-hskim/           # 기차 예매 시스템
├── *.sh                         # 관리 스크립트들
├── *.yaml                       # Kubernetes 리소스
└── README.md                    # 프로젝트 문서
```

## 🔧 설치 및 설정

### 1. 사전 요구사항

- Kubernetes 클러스터 (Minikube 권장)
- Istio 1.23.0
- kubectl
- curl

### 2. Istio 설치

```bash
# Istio 설치
istioctl install --set profile=demo -y

# Istio 애드온 설치
kubectl apply -f samples/addons/
```

### 3. Extended Bookinfo 배포

```bash
# Extended Bookinfo 배포
kubectl apply -f extended-bookinfo/

# 서비스 확인
kubectl get pods -n extended-bookinfo
```

## 🛠️ 관리 스크립트

### MTLS 설정
```bash
# PERMISSIVE 모드 (권장)
./mtls-setup.sh permissive

# STRICT 모드
./mtls-setup.sh strict

# MTLS 비활성화
./mtls-setup.sh disable

# 상태 확인
./mtls-setup.sh status
```

### 서비스 접속 정보
```bash
# 접속 URL 확인
./service-urls.sh

# Istio 규칙에 맞는 서비스 URL
./istio-service-urls.sh
```

### 트래픽 생성
```bash
# wrk를 사용한 트래픽 생성
./extended-bookinfo-wrk.sh

# MTLS 트래픽 생성
./generate-mtls-traffic.sh
```

### Loki 제거
```bash
# Loki 완전 제거
./remove-loki.sh
```

## 🌐 서비스 접속

### LoadBalancer 서비스
```bash
# Library Portal
curl http://192.168.76.2:31495

# User Service
curl http://192.168.76.2:32686

# Catalog Service
curl http://192.168.76.2:31812
```

### Istio IngressGateway
```bash
# IngressGateway를 통한 접속
curl http://192.168.76.2:31765/library
curl http://192.168.76.2:31765/user
curl http://192.168.76.2:31765/catalog
```

## 📊 모니터링

### Kiali
```bash
# Kiali 포트포워딩
kubectl port-forward -n istio-system svc/kiali 20001:20001

# 접속
http://localhost:20001
```

### Grafana
```bash
# Grafana 포트포워딩
kubectl port-forward -n istio-system svc/grafana 3000:3000

# 접속
http://localhost:3000
```

### Jaeger
```bash
# Jaeger 포트포워딩
kubectl port-forward -n istio-system svc/tracing 16686:16686

# 접속
http://localhost:16686
```

## 🔐 보안 설정

### MTLS 모드별 차이점

#### PERMISSIVE 모드
- ✅ 외부 접속 가능
- ✅ 서비스 간 MTLS 적용
- ✅ Kiali에서 관찰 가능
- ✅ 자물쇠 아이콘 표시

#### STRICT 모드
- ❌ 외부 접속 불가
- ✅ 서비스 간 MTLS 적용
- ❌ 외부 트래픽 없음
- ✅ 내부 자물쇠 아이콘 표시

## 📋 서비스 목록

1. **Library Portal**: 메인 포털
2. **User Service**: 사용자 관리
3. **Catalog Service**: 카탈로그 관리
4. **Inventory Service**: 재고 관리
5. **Order Service**: 주문 관리
6. **Payment Service**: 결제 관리
7. **Notification Service**: 알림 서비스
8. **Search Service**: 검색 서비스
9. **Recommendation Service**: 추천 서비스
10. **Analytics Service**: 분석 서비스
11. **Shipping Service**: 배송 서비스

## 🐛 문제 해결

### Istio 분석
```bash
# Istio 설정 분석
istioctl analyze -n extended-bookinfo

# 프록시 상태 확인
istioctl proxy-status
```

### 로그 확인
```bash
# Pod 로그 확인
kubectl logs -n extended-bookinfo <pod-name>

# Istio 프록시 로그
kubectl logs -n extended-bookinfo <pod-name> -c istio-proxy
```

## 📝 라이선스

이 프로젝트는 Apache License 2.0 하에 배포됩니다.

## 🤝 기여

버그 리포트나 기능 요청은 GitHub Issues를 통해 제출해주세요.

---

**최종 업데이트**: 2025년 8월 3일
