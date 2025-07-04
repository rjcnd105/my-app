/// <reference types="vite/client" />

declare module "*?url" {
  const src: string;
  export default src;
}

// Magical SVG plugin type declarations
declare module "*.svg" {
  // Default import: React component
  const ReactComponent: React.ComponentType<SVGProps<SVGSVGElement>>;
  export default ReactComponent;
}

declare module "*.svg?file" {
  // File URL import
  const src: string;
  export default src;
}
