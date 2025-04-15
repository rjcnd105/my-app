import { get, omit } from "es-toolkit/compat";
import { compileSchema, draft06 } from "json-schema-library";

const response = await fetch("http://localhost:4000/api/json/json_schema");

const schema = await response.json();

const room = schema.definitions.room;
const roomSchema = {
  schema: [draft06],
  ...room,

  properties: {
    ...omit(room.properties, "relationships"),
  },
};
const roomNode = compileSchema(roomSchema);
console.debug(roomSchema.properties);
// console.log("roomNode", roomNode);

// console.log(get(get(schemaNode.$defs, "room")?.getNode("id"), ["node"]));
