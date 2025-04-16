import { createFileRoute } from "@tanstack/react-router";
import * as v from "valibot";

const SearchParams = v.object({
  payer: v.string(),
});

const parser = v.parser(SearchParams);

export const Route = createFileRoute("/room/$shortId/add_pay_items")({
  component: RouteComponent,
  validateSearch: parser,
});

function RouteComponent() {
  return <div>Hello "/room/addPayItems"!</div>;
}
