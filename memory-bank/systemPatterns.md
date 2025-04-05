# 시스템 패턴

## 아키텍처 개요
Deopjib은 Elixir 기반의 Phoenix Framework와 Ash Framework를 결합한 웹 애플리케이션입니다. 이 시스템은 다음과 같은 주요 아키텍처 패턴을 따릅니다:

1. **도메인 주도 설계(DDD)**: Ash Framework를 통해 비즈니스 도메인을 명확하게 모델링
2. **실시간 웹 애플리케이션**: Phoenix LiveView와 Channels를 활용한 실시간 상호작용
3. **함수형 프로그래밍**: Elixir의 불변성과 패턴 매칭을 활용한 견고한 코드 작성
4. **BEAM 가상 머신**: Erlang VM의 동시성 모델을 활용한 확장성 있는 시스템 구축

## 주요 기술적 결정

### Ash Framework 사용
- **결정 이유**: 복잡한 비즈니스 로직과 관계를 선언적으로 정의하고 관리하기 위함
- **이점**: 강력한 데이터 검증, 권한 관리, 관계 처리 기능 제공
- **도전 과제**: Phoenix와의 통합 시 폼 처리 및 검증 로직 조정 필요

### Phoenix LiveView 사용
- **결정 이유**: JavaScript 코드를 최소화하면서 실시간 사용자 경험 제공
- **이점**: 서버 상태와 클라이언트 UI의 자동 동기화, 개발 생산성 향상
- **도전 과제**: 복잡한 UI 상태 관리와 성능 최적화

### PostgreSQL 데이터베이스
- **결정 이유**: 관계형 데이터 모델에 적합하며 Ash Framework와의 호환성
- **이점**: 트랜잭션 지원, 데이터 무결성, 확장성
- **구현 방식**: AshPostgres를 통한 데이터베이스 연동

## 디자인 패턴

### 리소스 중심 설계 (Ash Framework)
```elixir
defmodule Deopjib.Settlement.Room do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :expiration_at, :utc_datetime
    timestamps()
  end

  relationships do
    has_many :payers, Deopjib.Settlement.Payer
    # 기타 관계 정의
  end

  actions do
    create :upsert_with_payers do
      argument :payers, {:array, :map}
      change manage_relationship(:payers, type: :create)
      # 검증 로직
    end
    # 기타 액션 정의
  end
end
```

### LiveView 컴포넌트 패턴
```elixir
def render(assigns) do
  ~H"""
  <.form for={@form} phx-submit="save">
    <.input field={@form[:name]} label="방 이름" />

    <div class="payers">
      <.inputs_for :let={payer_form} field={@form[:payers]}>
        <.input field={payer_form[:name]} label="참여자 이름" />
      </.inputs_for>

      <button type="button" phx-click="add-payer">참여자 추가</button>
    </div>

    <.button type="submit">저장</.button>
  </.form>
  """
end
```

### 이벤트 기반 통신
```elixir
# 이벤트 발행
def create_message(room, message_params, user) do
  # 메시지 생성 로직
  with {:ok, message} <- Message.create(params) do
    Phoenix.PubSub.broadcast(
      Deopjib.PubSub,
      "room:#{room.id}",
      {:new_message, message}
    )
    {:ok, message}
  end
end

# 이벤트 구독
def mount(%{"id" => room_id}, _session, socket) do
  Phoenix.PubSub.subscribe(Deopjib.PubSub, "room:#{room_id}")
  # 기타 마운트 로직
end

# 이벤트 처리
def handle_info({:new_message, message}, socket) do
  {:noreply, update(socket, :messages, &[message | &1])}
end
```

## 컴포넌트 관계

### 핵심 도메인 모델
- **Room**: 정산 방 정보 관리
- **Payer**: 비용 지불자 정보 관리
- **Item**: 정산 항목 관리
- **Settlement**: 최종 정산 결과 관리

### 컴포넌트 간 상호작용
1. **사용자 → LiveView**: 사용자 입력 및 이벤트 처리
2. **LiveView → Ash Actions**: 비즈니스 로직 실행 요청
3. **Ash Actions → 데이터베이스**: 데이터 저장 및 조회
4. **Ash → LiveView**: 결과 반환 및 UI 업데이트
5. **PubSub → LiveView**: 실시간 이벤트 전파

## 중요 구현 경로

### 방 생성 및 참여자 추가 흐름
1. 사용자가 방 생성 폼 작성
2. LiveView가 폼 데이터 검증
3. Ash Action을 통해 Room 리소스 생성
4. 관계 관리를 통해 Payer 리소스 생성
5. 생성된 방으로 리다이렉트

### 폼 검증 처리 흐름
1. 사용자 입력 시 `phx-change` 이벤트 발생
2. LiveView의 `handle_event` 함수에서 처리
3. Ash Changeset을 통한 데이터 검증
4. 검증 결과를 폼에 반영
5. 오류 메시지 표시 또는 다음 단계 진행

### 실시간 업데이트 흐름
1. 데이터 변경 시 PubSub 이벤트 발행
2. 구독 중인 모든 LiveView 프로세스에 이벤트 전달
3. `handle_info` 콜백에서 이벤트 처리
4. 소켓 상태 업데이트
5. UI 자동 리렌더링
