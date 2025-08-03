#!/bin/bash

# MTLS 트래픽 생성 스크립트

echo "🚀 MTLS 트래픽 생성"
echo "==================="

echo "📊 현재 MTLS 상태:"
./mtls-setup.sh status

echo ""
echo "🌐 서비스 간 MTLS 트래픽 생성:"
echo "-----------------------------"

# Pod 내부에서 서비스 간 통신 생성
echo "1. Library Portal에서 User Service 호출:"
kubectl exec -n extended-bookinfo library-portal-v1-7b7b8f8c55-4w44r -c library-portal -- curl -s http://user-service-istio:9080/health

echo ""
echo "2. User Service에서 Catalog Service 호출:"
kubectl exec -n extended-bookinfo user-service-v1-6d466d5c96-gf2v4 -c user-service -- curl -s http://catalog-service-istio:9080/health

echo ""
echo "3. Catalog Service에서 Order Service 호출:"
kubectl exec -n extended-bookinfo catalog-service-v1-6645f76984-plbxc -c catalog-service -- curl -s http://order-service-istio:9080/health

echo ""
echo "4. Order Service에서 Payment Service 호출:"
kubectl exec -n extended-bookinfo order-service-v1-785dcd78ff-g69bp -c order-service -- curl -s http://payment-service-istio:9080/health

echo ""
echo "5. 외부에서 서비스 접속 (PERMISSIVE 모드에서만 작동):"
MINIKUBE_IP=$(minikube ip -p istiotest)

for i in {1..5}; do
    echo "트래픽 생성 중... $i/5"
    curl -s http://$MINIKUBE_IP:31495 > /dev/null
    curl -s http://$MINIKUBE_IP:32686 > /dev/null
    curl -s http://$MINIKUBE_IP:31812 > /dev/null
    sleep 2
done

echo ""
echo "✅ MTLS 트래픽 생성 완료!"
echo ""
echo "📈 Kiali에서 확인할 점:"
echo "----------------------"
echo "1. Traffic Graph > Security 옵션 ON"
echo "2. 서비스 간 연결선에 자물쇠 아이콘 확인"
echo "3. Services > Security 탭에서 MTLS 상태 확인"
echo ""
echo "🌐 Kiali 접속: http://localhost:20001" 