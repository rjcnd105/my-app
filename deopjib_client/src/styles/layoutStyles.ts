import { StyleSheet } from "react-native-unistyles";

export const layoutStyles = StyleSheet.create((theme) => ({
  centerContainer: {
    flex: 1,
    flexDirection: "column",
    justifyContent: "center",
    paddingLeft: {
      xs: 2,
      sm: 12,
      md: 16,
    },
    paddingRight: {
      xs: 2,
      sm: 12,
      md: 16,
    },
    paddingTop: 40,
    paddingBottom: 40,
  },
}));
