#!/bin/bash

# Istio IngressGateway를 통한 Extended Bookinfo 서비스 접속 정보

MINIKUBE_IP=$(minikube ip -p istiotest)
INGRESS_PORT=$(minikube service list -p istiotest | grep istio-ingressgateway | awk '{print $4}' | cut -d':' -f2 | cut -d'/' -f1)

echo "🌐 Istio IngressGateway를 통한 서비스 접속 정보"
echo "================================================"
echo "📍 Minikube IP: $MINIKUBE_IP"
echo "🔗 IngressGateway Port: $INGRESS_PORT"
echo ""

echo "📚 Istio IngressGateway를 통한 접속 (권장):"
echo "--------------------------------------------"
echo "Library Portal:     http://$MINIKUBE_IP:$INGRESS_PORT/library"
echo "User Service:       http://$MINIKUBE_IP:$INGRESS_PORT/user"
echo "Catalog Service:    http://$MINIKUBE_IP:$INGRESS_PORT/catalog"
echo "Order Service:      http://$MINIKUBE_IP:$INGRESS_PORT/order"
echo "Payment Service:    http://$MINIKUBE_IP:$INGRESS_PORT/payment"
echo ""

echo "🔗 Istio 규칙에 맞는 LoadBalancer 서비스:"
echo "----------------------------------------"
echo "Library Portal:     http://$MINIKUBE_IP:$(kubectl get svc library-portal-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "User Service:       http://$MINIKUBE_IP:$(kubectl get svc user-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Catalog Service:    http://$MINIKUBE_IP:$(kubectl get svc catalog-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Inventory Service:  http://$MINIKUBE_IP:$(kubectl get svc inventory-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Order Service:      http://$MINIKUBE_IP:$(kubectl get svc order-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Payment Service:    http://$MINIKUBE_IP:$(kubectl get svc payment-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Notification:       http://$MINIKUBE_IP:$(kubectl get svc notification-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Search Service:     http://$MINIKUBE_IP:$(kubectl get svc search-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Recommendation:     http://$MINIKUBE_IP:$(kubectl get svc recommendation-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Analytics Service:  http://$MINIKUBE_IP:$(kubectl get svc analytics-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo "Shipping Service:   http://$MINIKUBE_IP:$(kubectl get svc shipping-service-istio -n extended-bookinfo -o jsonpath='{.spec.ports[0].nodePort}')"
echo ""

echo "🔧 MTLS 설정:"
echo "-------------"
echo "./mtls-setup.sh permissive  # 권장 (PERMISSIVE 모드)"
echo "./mtls-setup.sh strict      # STRICT 모드"
echo "./mtls-setup.sh disable     # MTLS 비활성화"
echo "./mtls-setup.sh status      # 현재 상태 확인"
echo ""

echo "📊 모니터링:"
echo "------------"
echo "Kiali: http://localhost:20001"
echo "Grafana: http://localhost:3000"
echo "Jaeger: http://localhost:16686"
echo ""

echo "🧪 테스트 명령어:"
echo "----------------"
echo "curl -s http://$MINIKUBE_IP:$INGRESS_PORT/library | head -10"
echo "curl -s http://$MINIKUBE_IP:$INGRESS_PORT/user | head -10"
echo "curl -s http://$MINIKUBE_IP:$INGRESS_PORT/catalog | head -10"
echo ""

echo "📋 Istio 리소스 확인:"
echo "---------------------"
echo "kubectl get gateway -n extended-bookinfo"
echo "kubectl get virtualservice -n extended-bookinfo"
echo "kubectl get svc -n extended-bookinfo | grep istio" 