#!/bin/bash

# MTLS 설정 테스트 스크립트

echo "🔐 MTLS 설정 테스트"
echo "==================="

echo "📊 현재 MTLS 상태:"
./mtls-setup.sh status

echo ""
echo "🌐 서비스 접속 테스트:"
echo "----------------------"

MINIKUBE_IP=$(minikube ip -p istiotest)

echo "1. Library Portal 접속 테스트:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$MINIKUBE_IP:31495

echo ""
echo "2. User Service 접속 테스트:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$MINIKUBE_IP:32686

echo ""
echo "3. Catalog Service 접속 테스트:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$MINIKUBE_IP:31812

echo ""
echo "🔍 Istio 프록시 상태 확인:"
echo "---------------------------"

echo "1. Library Portal 프록시 상태:"
istioctl proxy-status | grep library-portal

echo ""
echo "2. 인증서 정보:"
istioctl proxy-config secret library-portal-v1-7b7b8f8c55-4w44r -n extended-bookinfo

echo ""
echo "📋 DestinationRule 확인:"
echo "-----------------------"
kubectl get destinationrule -n extended-bookinfo

echo ""
echo "🔧 MTLS 모드 변경 테스트:"
echo "------------------------"
echo "PERMISSIVE 모드 (현재):"
./mtls-setup.sh permissive
echo "접속 테스트:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$MINIKUBE_IP:31495

echo ""
echo "STRICT 모드:"
./mtls-setup.sh strict
echo "접속 테스트 (외부에서 접속 불가):"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$MINIKUBE_IP:31495

echo ""
echo "PERMISSIVE 모드로 복원:"
./mtls-setup.sh permissive

echo ""
echo "📈 Kiali에서 확인할 점:"
echo "----------------------"
echo "1. Istio Config > PeerAuthentication: 초록색 체크마크"
echo "2. Traffic Graph > Security 옵션 ON: 자물쇠 아이콘 확인"
echo "3. Services > Security 탭: MTLS 적용 상태"
echo ""
echo "🌐 Kiali 접속: http://localhost:20001" 