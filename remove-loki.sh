#!/bin/bash

# Loki 완전 제거 스크립트

echo "🗑️ Loki 완전 제거"
echo "=================="

echo "📋 현재 Loki 상태 확인..."
echo "------------------------"

echo "1. Loki Pod 확인:"
kubectl get pods -n istio-system | grep loki

echo ""
echo "2. Loki 서비스 확인:"
kubectl get svc -n istio-system | grep loki

echo ""
echo "3. Loki PVC 확인:"
kubectl get pvc -n istio-system | grep loki

echo ""
echo "4. Loki ConfigMap 확인:"
kubectl get configmap -n istio-system | grep loki

echo ""
echo "5. Loki ServiceAccount 확인:"
kubectl get serviceaccount -n istio-system | grep loki

echo ""
echo "🗑️ Loki 리소스 삭제 중..."
echo "------------------------"

# StatefulSet 삭제
echo "1. Loki StatefulSet 삭제:"
kubectl delete statefulset loki -n istio-system --ignore-not-found=true

# 서비스 삭제
echo ""
echo "2. Loki 서비스들 삭제:"
kubectl delete svc loki loki-headless loki-memberlist -n istio-system --ignore-not-found=true

# PVC 삭제
echo ""
echo "3. Loki PVC 삭제:"
kubectl delete pvc storage-loki-0 -n istio-system --ignore-not-found=true

# ConfigMap 삭제
echo ""
echo "4. Loki ConfigMap 삭제:"
kubectl delete configmap loki loki-runtime -n istio-system --ignore-not-found=true

# ServiceAccount 삭제
echo ""
echo "5. Loki ServiceAccount 삭제:"
kubectl delete serviceaccount loki -n istio-system --ignore-not-found=true

# ClusterRole/ClusterRoleBinding 삭제
echo ""
echo "6. Loki ClusterRole/ClusterRoleBinding 삭제:"
kubectl delete clusterrole loki --ignore-not-found=true
kubectl delete clusterrolebinding loki --ignore-not-found=true

# NetworkPolicy 삭제
echo ""
echo "7. Loki NetworkPolicy 삭제:"
kubectl delete networkpolicy -n istio-system --selector=app=loki --ignore-not-found=true

echo ""
echo "✅ Loki 제거 완료!"
echo ""

echo "📊 제거 후 확인:"
echo "---------------"
echo "1. Loki Pod:"
kubectl get pods -n istio-system | grep loki || echo "Loki Pod 없음"

echo ""
echo "2. Loki 서비스:"
kubectl get svc -n istio-system | grep loki || echo "Loki 서비스 없음"

echo ""
echo "3. Loki PVC:"
kubectl get pvc -n istio-system | grep loki || echo "Loki PVC 없음"

echo ""
echo "4. 리소스 사용량 확인:"
kubectl top nodes
kubectl top pods -n istio-system

echo ""
echo "🎉 Loki 완전 제거 완료!" 