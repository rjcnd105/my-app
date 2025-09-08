
import { type } from "arktype";


export namespace Room {
  export const schema = {
    new:  type({
      name: "0 < string <= 10"
    }),
  }
  export namespace Schema {
    export type New = typeof schema.new.infer
  }
}
