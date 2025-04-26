# Deopjib 애플리케이션 개발 가이드

이 Elixir/Phoenix 애플리케이션은 Ash Framework를 중심으로 리소스 지향적이고 선언적인 설계 원칙을 따릅니다.

## 기술 스택
- Elixir 1.18+
- Phoenix 1.7+ & LiveView
- Ash Framework 3.4+
- PostgreSQL (AshPostgres)
- TypeScript (클라이언트)

## 리소스 설계 원칙
- 리소스는 완전한 도메인 객체로 모델링 (CRUD 이상의 도메인 로직 포함)
- 선언적 DSL을 통해 의도를 명확히 표현
- 관심사 분리: 데이터 구조, 관계, 비즈니스 로직, API 레이어 분리

## 코드 구조
- `lib/deopjib/settlement/*.ex` - 정산 도메인 리소스
- `lib/deopjib_web/` - 웹 인터페이스 레이어
- `lib/deopjib_web/live/` - LiveView 컴포넌트

## Ash Framework 가이드라인
1. **리소스 정의**:
   - 명확한 속성 타입과 제약조건 지정
   - 관계는 명시적으로 양방향 정의 권장
   - 계산 필드로 파생 데이터 모델링

2. **액션 설계**:
   - 기본 CRUD 외 도메인별 액션 정의
   - 검증과 변환은 액션 내부에서 처리
   - 트랜잭션 단위로 복잡한 작업 그룹화

3. **코드 인터페이스**:
   - 공개 API는 code_interface로 명확히 정의
   - 일관된 함수 이름과 인자 형식 유지

## 타입 지정과 스펙

```elixir
@type settlement_result :: {:ok, PaymentSummary.t()} | {:error, term()}

@spec process_settlement(Room.t(), [Payer.t()]) :: settlement_result()
def process_settlement(room, payers) do
  # 구현...
end
```

## 현재 트렌드 적용 포인트
- **불변성 설계**: Ash의 변경 추적 활용
- **명확한 경계**: 도메인 간 상호작용은 공식 API로만
- **LiveView와 실시간 기능**: 정산 상태 업데이트를 실시간으로 전파
- **점진적 타입 시스템**: Elixir 타입스펙 + TypedStruct 조합

## 확장성을 위한 조언
- 도메인 로직은 Resources와 Domains에 집중
- 인프라 관련 코드는 하위 모듈로 분리
- 기능별 명확한 도메인 정의 (`Settlement`, `Accounts` 등)
- 리소스 간 결합도 최소화
```
