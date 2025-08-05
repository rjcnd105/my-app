// Import  global CSS file

import { BottomSheetModalProvider } from "@gorhom/bottom-sheet";
import { ThemeProvider } from "@react-navigation/native";
import { Stack } from "expo-router";
import React from "react";
import { StyleSheet } from "react-native";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { KeyboardProvider } from "react-native-keyboard-controller";

export { ErrorBoundary } from "expo-router";

export const unstable_settings = {
  initialRouteName: "(app)",
};

// hydrateAuth();
// loadSelectedTheme();
// // Prevent the splash screen from auto-hiding before asset loading is complete.
// SplashScreen.preventAutoHideAsync();
// // Set the animation options. This is optional.
// SplashScreen.setOptions({
//   duration: 500,
//   fade: true,
// });

export default function RootLayout() {
  return (
    <Providers>
      <Stack>
        <Stack.Screen name="(app)" options={{ headerShown: false }} />
        <Stack.Screen name="onboarding" options={{ headerShown: false }} />
        <Stack.Screen name="login" options={{ headerShown: false }} />
      </Stack>
    </Providers>
  );
}

function Providers({ children }: { children: React.ReactNode }) {
  return (
    <GestureHandlerRootView style={styles.container}>
      <KeyboardProvider>
        <BottomSheetModalProvider>{children}</BottomSheetModalProvider>
      </KeyboardProvider>
    </GestureHandlerRootView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
