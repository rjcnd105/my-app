import { createFileRoute } from "@tanstack/react-router";
import { NotFound } from "@/components/NotFound";
import { PostErrorComponent } from "@/components/PostError";
import { fetchPost } from "../utils/posts";

export const Route = createFileRoute("/$roomId/add_items")({
  loader: ({ params: { roomId } }) => fetchPost({ data: roomId }),
  errorComponent: PostErrorComponent,
  component: PostComponent,
  notFoundComponent: () => {
    return <NotFound>Post not found</NotFound>;
  },
});

function PostComponent() {
  const post = Route.useLoaderData();

  return (
    <div className="space-y-2">
      <h4 className="text-xl font-bold underline">{post.title}</h4>
      <div className="text-sm">{post.body}</div>
      dd
    </div>
  );
}
