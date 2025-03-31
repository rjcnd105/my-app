# 기술 컨텍스트

## 사용 기술

### 백엔드
- **Elixir 1.18**: 함수형 프로그래밍 언어, BEAM VM 위에서 실행
- **Phoenix Framework 1.0**: 웹 애플리케이션 프레임워크
- **Phoenix LiveView 1.0**: 실시간 사용자 인터페이스 구현
- **Ash Framework 3.5**: 도메인 모델링 및 비즈니스 로직 처리
- **AshPostgres**: Ash Framework와 PostgreSQL 연동
- **AshPhoenix**: Ash Framework와 Phoenix 통합
- **Ecto**: 데이터베이스 래퍼 및 쿼리 빌더
- **Phoenix PubSub**: 실시간 메시징 시스템

### 프론트엔드
- **Phoenix LiveView**: 서버 기반 실시간 UI
- **TailwindCSS**: 유틸리티 기반 CSS 프레임워크
- **Alpine.js**: 경량 JavaScript 프레임워크 (필요 시)
- **HeroIcons**: 아이콘 라이브러리

### 데이터베이스
- **PostgreSQL 17**: 관계형 데이터베이스
- **Migrations**: Ecto 마이그레이션을 통한 스키마 관리

### 개발 도구
- **Mix**: Elixir 빌드 도구
- **ExUnit**: 테스트 프레임워크
- **Floki**: HTML 파싱 (테스트용)
- **Nix**: 개발 환경 관리
- **Mise**: 버전 관리

## 개발 환경 설정

### 로컬 개발 환경
```bash
# 필수 도구 설치
brew install elixir postgresql

# 프로젝트 설정
mix deps.get
mix ecto.setup

# 개발 서버 실행
mix phx.server
```

### Nix 기반 개발 환경
```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            postgresql
            nodejs
            # 기타 필요한 패키지
          ];
          
          shellHook = ''
            # 환경 변수 설정
            export DATABASE_URL="postgresql://postgres:postgres@localhost/deopjib_dev"
          '';
        };
      }
    );
}
```

## 의존성 관리

### Mix 의존성
```elixir
# mix.exs
defp deps do
  [
    {:phoenix, "~> 1.0"},
    {:phoenix_live_view, "~> 1.0"},
    {:ash, "~> 3.5"},
    {:ash_postgres, "~> 3.0"},
    {:ash_phoenix, "~> 2.0"},
    {:ecto_sql, "~> 3.10"},
    {:postgrex, ">= 0.0.0"},
    {:phoenix_html, "~> 4.0"},
    {:phoenix_live_reload, "~> 2.0", only: :dev},
    {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
    {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
    # 기타 의존성
  ]
end
```

### 자산 관리
```elixir
# config/config.exs
config :deopjib, DeopjibWeb.Endpoint,
  # ...
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]
```

## 기술적 제약 조건

### 성능 고려사항
- **LiveView 상태 관리**: 대규모 데이터셋 처리 시 메모리 사용량 최적화 필요
- **실시간 업데이트**: 다수의 동시 사용자가 있을 때 PubSub 메시지 처리 최적화
- **데이터베이스 쿼리**: N+1 쿼리 문제 방지를 위한 적절한 관계 로딩

### 보안 고려사항
- **사용자 인증**: Phoenix.Auth를 통한 안전한 인증 처리
- **데이터 접근 제어**: Ash Framework의 권한 시스템 활용
- **CSRF 보호**: Phoenix 기본 CSRF 보호 메커니즘 활용

### 배포 고려사항
- **무중단 배포**: BEAM의 핫 코드 리로딩 활용
- **상태 관리**: 분산 환경에서의 상태 관리 전략
- **데이터베이스 마이그레이션**: 안전한 마이그레이션 전략

## 개발 패턴 및 관행

### 코드 구성
- **엄브렐라 프로젝트**: 핵심 비즈니스 로직과 웹 인터페이스 분리
- **컨텍스트 기반 구성**: 기능별 컨텍스트로 코드 구성
- **리소스 중심 설계**: Ash Framework 리소스를 중심으로 도메인 모델 구성

### 테스트 전략
- **단위 테스트**: 개별 함수 및 모듈 테스트
- **통합 테스트**: 컨텍스트 간 상호작용 테스트
- **시스템 테스트**: 전체 시스템 흐름 테스트
- **LiveView 테스트**: 사용자 인터페이스 동작 테스트

### 오류 처리
- **패턴 매칭**: 결과 튜플(`{:ok, result}` 또는 `{:error, reason}`)을 통한 오류 처리
- **Ash 오류 처리**: Ash Framework의 구조화된 오류 시스템 활용
- **사용자 친화적 오류 메시지**: 오류를 사용자가 이해하기 쉬운 형태로 변환

## 도구 사용 패턴

### LiveView 개발 패턴
- **이벤트 처리**: `handle_event/3` 콜백을 통한 사용자 이벤트 처리
- **폼 처리**: `AshPhoenix.Form`을 통한 폼 데이터 처리
- **실시간 업데이트**: `handle_info/2` 콜백을 통한 PubSub 메시지 처리

### Ash Framework 사용 패턴
- **리소스 정의**: 도메인 엔티티를 Ash 리소스로 정의
- **액션 정의**: CRUD 및 커스텀 액션을 통한 비즈니스 로직 구현
- **관계 관리**: `manage_relationship` 변경을 통한 관계 데이터 처리
- **검증 로직**: 리소스 및 액션 수준의 검증 규칙 정의
