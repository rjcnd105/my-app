module.exports = (api) => {
	api.cache(true);

	return {
		// for bare React Native
		// presets: ['module:@react-native/babel-preset'],

		// or for Expo
		presets: ["babel-preset-expo"],
		plugins: [
			[
				"module-resolver",
				{
					root: ["./"],
					alias: {
						"@": "./src",
					},
					extensions: [
						".ios.ts",
						".android.ts",
						".ts",
						".ios.tsx",
						".android.tsx",
						".tsx",
						".jsx",
						".js",
						".json",
					],
				},
			],
			// 맨 마지막에 위치해야함
			"react-native-reanimated/plugin",
		],
	};
 };
