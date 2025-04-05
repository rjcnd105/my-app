# 활성 컨텍스트

## 현재 작업 초점
현재 Deopjib 프로젝트에서는 Ash Framework와 Phoenix LiveView를 통합하여 폼 검증 및 데이터 처리를 구현하는 데 초점을 맞추고 있습니다. 특히 중첩된 폼(nested forms)에서 발생하는 검증 오류를 적절히 처리하고 사용자에게 표시하는 방법을 개선하고 있습니다.

## 최근 변경 사항
- Ash Framework를 사용하여 Room과 Payer 리소스 간의 관계 정의
- AshPhoenix.Form을 활용한 중첩 폼 구현
- 중복 이름 검증 로직 추가 (같은 이름의 참여자가 있을 경우 오류 발생)
- Phoenix.HTML.Form과 AshPhoenix.Form 간의 통합 작업

## 현재 문제점
현재 직면한 주요 문제는 Ash.Form.add_form을 사용하면서 validate를 실행했을 때, source에 해당하는 Ash.Form은 valid?: false로 올바르게 표시되지만, 이를 감싸는 Phoenix.HTML.Form에서는 에러가 제대로 표시되지 않는 현상입니다. 구체적으로:

```elixir
# 에러가 있는 Ash.Changeset
errors: [
  %Ash.Error.Changes.InvalidChanges{
    fields: nil,
    message: "이미 같은 이름이 있어",
    validation: nil,
    value: nil,
    splode: nil,
    bread_crumbs: [],
    vars: [],
    path: [],
    stacktrace: #Splode.Stacktrace<>,
    class: :invalid
  }
],
valid?: false
```

하지만 이 Changeset을 감싸는 Phoenix.HTML.Form 객체의 errors 배열은 비어 있고, 검증 상태가 제대로 반영되지 않습니다.

## 해결 접근법
이 문제를 해결하기 위한 몇 가지 접근법을 검토 중입니다:

1. **transform_errors 옵션 활용**:
   ```elixir
   AshPhoenix.Form.for_create(Deopjib.Settlement.Room, :upsert_with_payers,
     transform_errors: fn errors ->
       # Ash 에러를 Phoenix 폼에서 사용할 수 있는 형식으로 변환
       Enum.map(errors, fn error ->
         case error do
           %Ash.Error.Changes.InvalidChanges{message: message} ->
             {"payers", message}
           _ ->
             {error.field || :base, error.message}
         end
       end)
     end
   )
   ```

2. **템플릿에서 직접 에러 처리**:
   ```heex
   <.form for={@form} phx-submit="save">
     <!-- 폼 필드들 -->

     <!-- 전체 폼 에러 표시 -->
     <%= if @form.source && !@form.source.valid? do %>
       <div class="alert alert-danger">
         <%= for error <- @form.source.errors do %>
           <p><%= error.message %></p>
         <% end %>
       </div>
     <% end %>

     <!-- 중첩된 폼의 에러 표시 -->
     <%= for {_id, payer_form} <- @form.forms.payers do %>
       <!-- 각 payer 폼 필드 -->
       <%= if payer_form.source && !payer_form.source.valid? do %>
         <div class="text-red-500">
           <%= for error <- payer_form.source.errors do %>
             <p><%= error.message %></p>
           <% end %>
         </div>
       <% end %>
     <% end %>
   </.form>
   ```

3. **커스텀 검증 함수 구현**:
   ```elixir
   def validate_unique_payer_names(changeset) do
     payers = Ash.Changeset.get_argument(changeset, :payers) || []

     names = Enum.map(payers, & &1.name)
     duplicates = names -- Enum.uniq(names)

     if duplicates != [] do
       Ash.Changeset.add_error(changeset,
         message: "이미 같은 이름이 있어",
         field: :payers
       )
     else
       changeset
     end
   end
   ```

## 다음 단계
1. 선택한 접근법을 구현하고 테스트
2. 폼 검증 오류 표시 UI 개선
3. 다른 중첩 관계(예: 정산 항목)에도 동일한 패턴 적용
4. 사용자 경험 테스트 및 피드백 수집

## 활성 결정 및 고려 사항
- **에러 처리 전략**: Ash 에러를 Phoenix 폼에 어떻게 효과적으로 전파할 것인가?
- **UI/UX 고려사항**: 사용자에게 검증 오류를 어떻게 명확하게 표시할 것인가?
- **코드 구성**: 검증 로직을 리소스 정의에 포함시킬 것인가, 아니면 별도의 모듈로 분리할 것인가?
- **성능 최적화 고려사항**: LiveView 컴포넌트에서 비효율적인 데이터 로딩, 디버깅 코드, 비효율적인 리스트 처리, 불필요한 DOM 업데이트 등을 식별하고 개선하는 방법

- **성능 고려사항**: 복잡한 중첩 폼에서 검증 성능을 어떻게 최적화할 것인가?

## 중요한 패턴 및 선호도
- **명시적 에러 처리**: 오류를 숨기지 않고 명시적으로 처리하여 디버깅 용이성 확보
- **사용자 중심 메시지**: 기술적 오류 메시지가 아닌 사용자가 이해하기 쉬운 메시지 제공
- **일관된 검증 패턴**: 프로젝트 전체에서 일관된 검증 패턴 사용
- **테스트 주도 개발**: 검증 로직에 대한 철저한 테스트 작성

## 학습 및 프로젝트 통찰력
- Ash Framework와 Phoenix의 통합은 강력하지만, 폼 처리와 검증 부분에서 추가적인 작업이 필요함
- 중첩된 관계에서의 검증은 단일 리소스 검증보다 복잡하며, 명확한 전략이 필요함
- 사용자 경험을 위해서는 기술적 구현 복잡성을 감수하더라도 명확한 오류 메시지와 안내가 중요함
- Phoenix LiveView와 Ash Framework의 조합은 실시간 검증 피드백을 제공하는 데 매우 효과적임

## 현재 작업 중인 코드 예시
```elixir
# Room 리소스 정의
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
  end

  actions do
    create :upsert_with_payers do
      argument :payers, {:array, :map}

      change manage_relationship(:payers, type: :create)

      # 중복 이름 검증
      validate {Deopjib.Settlement.Validations, :validate_unique_payer_names}
    end
  end
end

# LiveView 구현
defmodule DeopjibWeb.RoomLive.New do
  use DeopjibWeb, :live_view

  def mount(_params, _session, socket) do
    form = AshPhoenix.Form.for_create(Deopjib.Settlement.Room, :upsert_with_payers,
      transform_errors: &transform_errors/1
    )

    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params) do
      {:ok, room} ->
        {:noreply,
          socket
          |> put_flash(:info, "방이 생성되었습니다.")
          |> redirect(to: ~p"/rooms/#{room}")
        }

      {:error, form} ->
        {:noreply,
          socket
          |> put_flash(:error, "방 생성 중 오류가 발생했습니다.")
          |> assign(form: form)
        }
    end
  end

  defp transform_errors(errors) do
    Enum.map(errors, fn error ->
      case error do
        %Ash.Error.Changes.InvalidChanges{message: message} ->
          {"payers", message}
        _ ->
          {error.field || :base, error.message}
      end
    end)
  end
end
