import { vRoom } from "~/gen/api/valibot.gen.ts";
import type * as Gen from "../gen/api/types.gen.ts";
import { pipe } from "remeda";
import * as v from "valibot";

type RoomT = Gen.Room;
type RoomAttrT = RoomT["attributes"];

const Name = vRoom.entries.attributes.wrapped.entries.name;

const newSchema = v.object({
	name: Name,
});

export namespace Room {
	export const schema = {
		new: newSchema,
	};
	export type New = v.InferInput<typeof newSchema>;
}
