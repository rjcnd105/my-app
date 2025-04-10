import { createFileRoute } from "@tanstack/react-router";
import { Button } from "~/ui/Button/Button";

export const Route = createFileRoute("/")({
  component: Home,
});

function Home() {
  return (
    <div className="p-2">
      <Button theme="primary">hihi</Button>
      home
    </div>
  );
}
