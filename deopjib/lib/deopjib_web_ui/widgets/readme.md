# Widgets

## 개념

Widgets는 특정 비즈니스 기능을 독립적으로 수행할 수 있는 완전한 UI 컴포넌트입니다.
LiveComponent로 구현될 수 있습니다.

- **비즈니스 로직 포함**: 자체적인 상태 관리 및 비즈니스 로직 처리
- **독립적 기능**: 특정 비즈니스 기능을 독립적으로 수행
- **제한된 재사용**: 특정 도메인이나 기능에 특화됨
- **컴포넌트 조합**: Parts와 Composites를 조합하여 구성
- **API 통합**: 종종 백엔드 API와 직접 통신

## 용도

Widgets는 사용자 프로필 관리, 검색 기능, 알림 센터, 댓글 시스템 등과 같이 특정 비즈니스 기능을 완전히 구현하는 컴포넌트로 사용됩니다. 이들은 애플리케이션의 특정 부분에서 독립적으로 작동하며, 필요한 모든 로직과 상태 관리를 포함합니다.


## 주의사항

- Widgets는 특정 비즈니스 기능에 초점을 맞추므로 일반적 재사용성이 제한될 수 있습니다
- 복잡한 상태 관리가 필요한 경우가 많으므로 성능과 유지보수성에 주의해야 합니다
- 가능한 한 Props API를 통해 외부와 소통하여 테스트 용이성을 유지해야 합니다(사용상 편의를 위해 default값을 설정)


## 예시

```heex
<!-- 기본 사용법 -->
<.search
  initial_query={@query}
  categories={@available_categories}
  on_result_select={&handle_select/1}
/>

<!-- 특정 컨텍스트에서의 사용 -->
<.notification_center
  user_id={@current_user.id}
  max_items={10}
/>
```
