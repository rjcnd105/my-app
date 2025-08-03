import { vRoom } from "@/gen/api/valibot.gen.ts";
import type * as Gen from "../gen/api/types.gen.ts";

type RoomT = Gen.Room;
type RoomAttrT = RoomT["attributes"];

const Name = vRoom.entries.attributes.wrapped.entries.name;

const newSchema = z.object({
  name: Name,
});

export namespace Room {
  export const schema = {
    new: newSchema,
  };
  export type New = v.InferInput<typeof newSchema>;
}
