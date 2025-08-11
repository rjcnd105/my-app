import type { BoxShadowValue } from "react-native";
import { StyleSheet } from "react-native-unistyles";

// 색상 팔레트 정의
export const lightColors = {
  // Dark Gray Colors
  darkgray300: "#1C1C1C",
  darkgray200: "#4C4D4E",
  darkgray100: "#8D8D92",

  // Gray Colors
  gray300: "#BCBCC1",
  gray200: "#D4D4DA",
  gray100: "#E8E8EB",

  // Light Gray Colors
  lightgray200: "#EEEEF1",
  lightgray100: "#F5F5F9",

  // Blue Colors
  blue500: "#2F49E2",
  blue400: "#4E67F8",
  blue300: "#96A5FF",
  blue200: "#DBE0FF",
  blue100: "#EAEEFF",

  // Orange Colors
  orange300: "#FFFFFF",
  orange200: "#FFD482",
  orange100: "#FFF7E7",

  // Base Colors
  white: "#FFFFFF",
  black: "#1C1C1C",
  red: "#FB6258",
  none: "transparent",

  // Semantic Colors
  get bg() {
    return this.gray100;
  },
  get primary() {
    return this.blue400;
  },
  get secondary() {
    return this.blue300;
  },
  get sub() {
    return this.white;
  },
  get warning() {
    return this.red;
  },
  get success() {
    return this.blue500;
  },
  dimm: "rgba(0, 0, 0, 0.4)",
} as const;

export const typography = {
  caption3: {
    fontSize: 9,
    lineHeight: 12,
    fontWeight: 300,
  },
  caption2: {
    fontSize: 12,
    lineHeight: 16,
    fontWeight: 300,
  },
  caption1: {
    fontSize: 14,
    lineHeight: 18,
    fontWeight: 300,
  },
  body2: {
    fontSize: 16,
    lineHeight: 20,
  },
  body1: {
    fontSize: 18,
    lineHeight: 22,
  },
  subtitle: {
    fontSize: 20,
    lineHeight: 24,
  },
  title: {
    fontSize: 24,
    lineHeight: 28,
    fontWeight: 600,
  },
  heading: {
    fontSize: 32,
    lineHeight: 36,
    fontWeight: 700,
  },
};

// 블러 효과
export const blur = {
  dimm: 10,
} as const;

export const radius = {
  sm: 4,
  md: 8,
  lg: 12,
  full: 9999,
} as const;

export const shadows = {
  shadow1: {
    offsetX: 0,
    offsetY: -4,
    blurRadius: 8,
    color: "#000000",
  },
} as const satisfies Record<string, BoxShadowValue>;

export const utils = {
  gap: (v: number) => v * 2,
} as const;

export const breakpoints = {
  xs: 0,
  sm: 640,
  md: 1024,
  lg: 1600,
} as const;
