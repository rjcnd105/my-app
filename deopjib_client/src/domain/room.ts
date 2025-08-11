import { createCollection } from "@tanstack/react-db";
import { electricCollectionOptions } from "@tanstack/electric-db-collection";
import { z } from "zod";

export const RoomSchema = z.object({
  id: z.string(),
  name: z.string().trim().max(8).min(1),
  short_id: z.string(),
  updated_at: z.string(),
});

export const RoomInputSchema = RoomSchema.omit({
  id: true,
  updated_at: true,
  short_id: true,
});

type Room = z.output<typeof RoomSchema>;
type RoomInput = z.output<typeof RoomInputSchema>;

export const roomCollection = createCollection(
  electricCollectionOptions<Room>({
    id: "rooms",
    shapeOptions: {
      url: `${process.env.BASE_SERVER_URL}/v1/shape/room_read`,
    },

    getKey: (item) => item.id,
  }),
);
