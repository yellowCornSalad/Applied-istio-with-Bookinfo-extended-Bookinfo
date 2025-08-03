# GitHub 업로드 가이드

## 🚀 GitHub에 Istio 프로젝트 업로드하기

### 1단계: GitHub에서 새 저장소 생성

1. GitHub.com에 로그인
2. 우측 상단의 "+" 버튼 클릭 → "New repository"
3. 저장소 이름 입력: `istio-1.23.0-extended-bookinfo`
4. 설명 추가: `Istio 1.23.0 Extended Bookinfo 프로젝트`
5. Public 또는 Private 선택
6. "Create repository" 클릭

### 2단계: 원격 저장소 추가

```bash
# GitHub 저장소 URL을 원격 저장소로 추가
git remote add origin https://github.com/YOUR_USERNAME/istio-1.23.0-extended-bookinfo.git

# 또는 SSH를 사용하는 경우
git remote add origin git@github.com:YOUR_USERNAME/istio-1.23.0-extended-bookinfo.git
```

### 3단계: 브랜치 이름 변경 (선택사항)

```bash
# 기본 브랜치를 main으로 변경
git branch -M main
```

### 4단계: GitHub에 푸시

```bash
# 모든 파일을 GitHub에 업로드
git push -u origin main
```

### 5단계: 업로드 확인

1. GitHub 저장소 페이지 방문
2. 파일들이 정상적으로 업로드되었는지 확인
3. README.md가 자동으로 표시되는지 확인

## 📋 업로드된 파일들

### 주요 스크립트들
- `mtls-setup.sh`: MTLS 설정 관리
- `service-urls.sh`: 서비스 접속 URL 출력
- `istio-service-urls.sh`: Istio 규칙에 맞는 서비스 URL
- `generate-mtls-traffic.sh`: MTLS 트래픽 생성
- `remove-loki.sh`: Loki 제거
- `cleanup-istio-services.sh`: 서비스 정리

### Kubernetes 리소스들
- `loadbalancer-services.yaml`: LoadBalancer 서비스
- `istio-compliant-services.yaml`: Istio 규칙에 맞는 서비스
- `istio-gateway-vs.yaml`: Gateway 및 VirtualService
- `destination-rules.yaml`: DestinationRule

### 프로젝트 문서
- `README.md`: 프로젝트 설명 및 사용법
- `.gitignore`: Git에서 제외할 파일들

## 🔧 추가 설정

### GitHub Pages 설정 (선택사항)

1. 저장소 Settings → Pages
2. Source를 "Deploy from a branch"로 설정
3. Branch를 "main"으로 설정
4. Save 클릭

### 저장소 설명 업데이트

GitHub 저장소 페이지에서:
1. 저장소 설명 편집
2. Topics 추가: `istio`, `kubernetes`, `microservices`, `service-mesh`
3. 저장

## 📊 저장소 통계

- **총 파일 수**: 498개
- **주요 언어**: YAML, Shell Script, Markdown
- **프로젝트 크기**: 약 170MB

## 🎯 다음 단계

1. **Issues 생성**: 버그 리포트나 기능 요청
2. **Wiki 작성**: 상세한 사용법 문서
3. **Actions 설정**: CI/CD 파이프라인 구성
4. **커뮤니티 참여**: 다른 개발자들과 공유

---

**참고**: GitHub에 업로드하기 전에 민감한 정보(API 키, 비밀번호 등)가 포함되지 않았는지 확인하세요. 