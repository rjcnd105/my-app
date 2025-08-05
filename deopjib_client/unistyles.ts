import {
  breakpoints,
  lightColors,
  radius,
  shadows,
  typography,
  utils,
} from "@/styles/tokens";
import { StyleSheet } from "react-native-unistyles";

const lightTheme = {
  colors: lightColors,
  typography,
  ...utils,
  shadows,
  radius,
};

const themes = {
  light: lightTheme,
  dark: lightTheme,
};

const settings = {
  initialTheme: "light",
} as const;

type AppBreakpoints = typeof breakpoints;
type AppThemes = typeof themes;

declare module "react-native-unistyles" {
  export interface UnistylesThemes extends AppThemes {}
  export interface UnistylesBreakpoints extends AppBreakpoints {}
}

StyleSheet.configure({
  settings,
  themes,
  breakpoints,
});
