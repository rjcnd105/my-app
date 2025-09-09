import { createFileRoute } from "@tanstack/react-router";
import { NotFound } from "@shared/ui/NotFound";
import { PostErrorComponent } from "@shared/ui/PostError";

export const Route = createFileRoute("/$roomId/add_items")({
  errorComponent: PostErrorComponent,
  component: PostComponent,
  notFoundComponent: () => {
    return <NotFound>Post not found</NotFound>;
  },
});

function PostComponent() {

  return (
    <div className="space-y-2">
      {/* <h4 className="text-xl font-bold underline">{post.title}</h4>
      <div className="text-sm">{post.body}</div> */}
      dd
    </div>
  );
}
