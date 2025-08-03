#!/bin/bash

# Istio 서비스 정리 및 경고 해결 스크립트

echo "🧹 Istio 서비스 정리 및 경고 해결"
echo "=================================="

echo "📋 현재 서비스 상태 확인..."
kubectl get svc -n extended-bookinfo

echo ""
echo "🗑️ 중복 서비스 삭제 중..."

# NodePort 서비스들 삭제 (Istio 규칙에 맞는 서비스만 유지)
kubectl delete svc -n extended-bookinfo \
  library-portal-nodeport \
  user-service-nodeport \
  catalog-service-nodeport \
  inventory-service-nodeport \
  order-service-nodeport \
  payment-service-nodeport \
  notification-service-nodeport \
  search-service-nodeport \
  recommendation-service-nodeport \
  analytics-service-nodeport \
  shipping-service-nodeport

echo ""
echo "✅ 정리 완료!"
echo ""

echo "📊 정리 후 분석..."
istioctl analyze -n extended-bookinfo

echo ""
echo "🌐 접속 가능한 서비스들:"
echo "------------------------"
kubectl get svc -n extended-bookinfo | grep istio

echo ""
echo "🔧 MTLS 상태:"
./mtls-setup.sh status

echo ""
echo "📈 Kiali에서 확인하세요:"
echo "http://localhost:20001" 