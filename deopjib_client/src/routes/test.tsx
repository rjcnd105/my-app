import { createFileRoute } from "@tanstack/react-router";
import { createContext, useContext, } from "react";

export const Route = createFileRoute("/test")({
  component: RouteComponent,
});

type Item = {
  id: string;
  link: string;
};
type Section = {
  group: string;
  item: Item;
};

type GroupType = "product" | "hero";
type GroupMetaData = {
  type: GroupType;
};

type Actions = {
  CHANGE_GROUP: (group: string) => {
    type: "CHANGE_GROUP";
    payload: string;
  };
};

const items = [
  {
    id: "a",
    link: "/a",
  },
] as const satisfies Item[];

const _groupMeta = {
  aa: {
    type: "video-item",
  },
  product1: {
    type: "product",
  },
} as const;

const defaultValue = {
  group: "aa",
  item: items[0],
};

const context = createContext<Section>(defaultValue);

// function reducer(state: Section, action: Actions) {
//   switch (action) {
//     case "CHANGE_GROUP":
//       return {
//         ...state,
//         group: action.payload,
//       };
//     default:
//       return state;
//   }
// }

function RouteComponent() {
  return (
    <div>
      <video muted autoPlay playsInline controls={false} src="/videos/t1.mov" />
    </div>
  );
}

function _Provider({ children }: { children: React.ReactNode }) {
  // const value = useReducer(reducer, defaultValue);

  return <context.Provider value={defaultValue}>{children}</context.Provider>;
}

function _useProvider() {
  return useContext(context);
}
