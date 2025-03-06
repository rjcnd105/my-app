# Composites

## 개념

Composites는 여러 Parts를 조합하여 만든 더 복잡한 UI 구성 요소입니다.
FunctionComponent로 구현됩니다.

- **조합성**: 여러 Parts의 의미 있는 조합으로 구성
- **유연한 변형**: 다양한 상황에 맞게 변형 가능
- **외부 로직 의존**: 비즈니스 로직은 주로 외부에서 주입받음
- **중간 복잡도**: Parts보다 복잡하지만 Widgets보다는 단순
- **맥락 독립적**: 특정 비즈니스 도메인에 종속되지 않음

## 용도

Composites는 검색 바, 카드, 알림 창, 폼 그룹 등과 같이 여러 기본 요소가 함께 작동하여 특정 목적을 수행하는 UI 구성 요소로 사용됩니다. 이들은 애플리케이션 전반에 걸쳐 재사용되면서도 각 상황에 맞게 조정될 수 있습니다.


## 주의사항

- Composites는 자체적인 비즈니스 로직보다는 UI 로직에 중점을 둡니다
- 다양한 상황에서 재사용될 수 있도록 충분히 유연해야 합니다
- 너무 특정 도메인에 종속된 기능은 Widgets로 이동해야 합니다

## 예시

```heex
<!-- 기본 사용법 -->
<.search_bar
  placeholder="검색어를 입력하세요"
  on_search={&handle_search/1}
/>

<!-- 변형 사용 -->
<.card
  title="제품 정보"
  footer={&render_footer/1}
  variant="bordered"
>
  <:content>
    <p>카드 내용이 여기에 들어갑니다.</p>
  </:content>
</.card>
```
