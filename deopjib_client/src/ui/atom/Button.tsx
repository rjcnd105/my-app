import {
  Button as RNButton,
  type ButtonProps as RNButtonProps,
  Text,
} from "react-native";
import { StyleSheet } from "react-native-unistyles";

interface ButtonProps extends RNButtonProps {
  text: string;
}

export const Button = ({ text, ...props }: ButtonProps) => {
  return (
    <RNButton {...props}>
      <Text style={styles.text}>{text}</Text>
    </RNButton>
  );
};

const styles = StyleSheet.create((theme) => ({
  button: {
    backgroundColor: theme.colors.primary,
  },
  text: {
    color: theme.colors.darkgray300,
  },
}));
