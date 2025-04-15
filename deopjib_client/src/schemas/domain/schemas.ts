import type * as Gen from "../../gen/api/types.gen.ts";
import * as v from "valibot";

type RoomT = Gen.Room;
type RoomAttrT = RoomT["attributes"];

const Name = v.pipe(v.string(), v.minLength(1), v.maxLength(8));

export const Room = {
  Attr: {
    Name,
  },
};
