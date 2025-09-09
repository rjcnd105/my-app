import { View } from "@shared/ui/Templates/View";
import { createFileRoute } from "@tanstack/react-router";
import { type } from "arktype";

const SearchParams = type({
  payer: "string",
  id: "string.numeric | number"
});

type SearchParams = typeof SearchParams.infer;

export const Route = createFileRoute("/room/$shortId/add_pay_items")({
  component: RouteComponent,
  validateSearch: SearchParams,
});

function RouteComponent() {
  return <View transitionName="main">Hello "/room/addPayItems"!</View>;
}
