import { createRequest, gql } from "urql";
import { client } from "../client";
import { graphql } from "../generated";

// const getRoom = gql`
//   query room($shortId: String!) {
//     room(shortId: $shortId) {
//       shortId
//       name
//       countsOfPayers
//     }
//   }
// `;

const roomQueryDocument = graphql(/* GraphQL */ `
  query Room($shortId: String!) {
    room(shortId: $shortId) {
      shortId
      name
      countsOfPayers
    }
  }
`);
