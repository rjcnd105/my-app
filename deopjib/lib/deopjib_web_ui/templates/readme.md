# Templates

## 개념

Templates는 특정 유형의 페이지나 화면에 대한 구조와 레이아웃을 정의하는 컴포넌트입니다.

- **페이지 구조 정의**: 특정 유형의 페이지에 대한 내용 구성 방식 정의
- **데이터 표시 방식**: 어떤 데이터가 페이지에서 어떻게 표시될지 결정
- **컨텐츠 배치**: 위젯과 다른 UI 요소들의 배치 정의
- **일관된 페이지 유형**: 같은 유형의 여러 페이지에 일관된 구조 제공
- **Layout 활용**: 보통 특정 Layout 내에서 작동

## 용도

Templates는 제품 상세 페이지, 사용자 프로필 페이지, 대시보드 화면 등과 같이 특정 유형의 페이지에 대한 구조를 정의하는 데 사용됩니다. 이들은 실제 데이터가 어떻게 표시될지를 결정하며, LiveView에서 동일한 구조를 가진 여러 페이지를 일관되게 표현할 수 있게 합니다.



## 주의사항

- Templates는 페이지의 전체 구조와 컨텐츠 배치에 집중해야 합니다
- 비즈니스 로직보다는 UI 구성에 중점을 두어야 합니다
- 너무 많은 직접적인 데이터 처리는 피하고, 가능한 한 Widgets를 활용해야 합니다
- 일관된 디자인 언어를 유지하면서도 다양한 컨텐츠를 수용할 수 있어야 합니다


## 예시

```heex
<!-- LiveView에서의 사용 -->
<.product_detail
  product={@product}
  related_products={@related_products}
  reviews={@reviews}
  current_user={@current_user}
/>

<!-- 내부 구현 예시 -->
# product_detail.ex
def product_detail(assigns) do
  ~H"""
  <div class="product-page">
    <div class="product-header">
      <h1><%= @product.name %></h1>
      <p class="category"><%= @product.category %></p>
    </div>

    <div class="product-content">
      <div class="product-gallery">
        <.image_gallery images={@product.images} />
      </div>

      <div class="product-info">
        <.pricing product={@product} />
        <.product_actions product={@product} current_user={@current_user} />
      </div>
    </div>

    <div class="product-details">
      <.tabs>
        <:tab title="설명">
          <div class="description"><%= @product.description %></div>
        </:tab>
        <:tab title="사양">
          <.specifications specs={@product.specifications} />
        </:tab>
        <:tab title="리뷰">
          <.reviews reviews={@reviews} product_id={@product.id} />
        </:tab>
      </.tabs>
    </div>

    <div class="related-products">
      <h2>관련 제품</h2>
      <.product_list products={@related_products} />
    </div>
  </div>
  """
end
```
