import { createFileRoute } from "@tanstack/react-router";
import { Button } from "@shared/ui/Button/Button";
import { View } from "@shared/ui/Templates/View";

export const Route = createFileRoute("/room/create")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <View transitionName="main">
      <h2 className="text-title font-light">누구누구 정산할거야?</h2>

    </View>
  );
}
