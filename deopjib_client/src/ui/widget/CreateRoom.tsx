import { View, Text, TextInput } from "react-native";
import { StyleSheet } from "react-native-unistyles";
import { useForm } from "@tanstack/react-form";

export const CreateRoom = () => {
  const form = useForm();
  return (
    <View style={styles.container}>
      <form.Field name="name">
        {(field) => (
          <View>
            <Text>이름</Text>
            <TextInput
              value={field.state.value as string}
              onChangeText={field.handleChange}
            />
            {!field.state.meta.isValid && (
              <Text>{field.state.meta.errors.join(", ")}</Text>
            )}
          </View>
        )}
      </form.Field>
    </View>
  );
};

const styles = StyleSheet.create((theme) => ({
  container: {
    flex: 1,
    flexDirection: "column",
    backgroundColor: theme.colors.bg,
  },
}));
