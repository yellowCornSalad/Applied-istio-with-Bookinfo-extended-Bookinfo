#!/bin/bash

# MTLS 설정 관리 스크립트

echo "🔐 MTLS 설정 관리 스크립트"
echo "================================"

case "$1" in
    "permissive")
        echo "🔓 PERMISSIVE 모드로 설정합니다..."
        kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: disable-mtls
  namespace: extended-bookinfo
spec:
  mtls:
    mode: PERMISSIVE
EOF
        echo "✅ PERMISSIVE 모드 설정 완료"
        ;;
    "strict")
        echo "🔒 STRICT 모드로 설정합니다..."
        kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: disable-mtls
  namespace: extended-bookinfo
spec:
  mtls:
    mode: STRICT
EOF
        echo "✅ STRICT 모드 설정 완료"
        ;;
    "disable")
        echo "🚫 MTLS를 비활성화합니다..."
        kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: disable-mtls
  namespace: extended-bookinfo
spec:
  mtls:
    mode: DISABLE
EOF
        echo "✅ MTLS 비활성화 완료"
        ;;
    "status")
        echo "📊 현재 MTLS 상태:"
        kubectl get peerauthentication -n extended-bookinfo -o yaml
        ;;
    *)
        echo "사용법: $0 {permissive|strict|disable|status}"
        echo ""
        echo "옵션:"
        echo "  permissive - MTLS를 PERMISSIVE 모드로 설정 (권장)"
        echo "  strict     - MTLS를 STRICT 모드로 설정"
        echo "  disable    - MTLS를 완전히 비활성화"
        echo "  status     - 현재 MTLS 상태 확인"
        ;;
esac 