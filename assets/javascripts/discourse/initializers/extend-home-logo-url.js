import { withPluginApi } from "discourse/lib/plugin-api";

function extendHomeLogoUrl(api) {
	const siteSettings = api.container.lookup("site-settings:main");
	const categoryId = Number.parseInt(siteSettings.home_category_id, 10);
	if (!Number.isFinite(categoryId)) {
		return;
	}

	const href = `/c/${categoryId}`;
	api.registerValueTransformer("home-logo-href", () => href);
}

export default {
	name: "extend-home-logo-url",
	initialize: () => {
		withPluginApi("1.0.0", extendHomeLogoUrl);
	},
};
