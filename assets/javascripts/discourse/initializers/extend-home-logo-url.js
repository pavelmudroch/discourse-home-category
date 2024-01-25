import { withPluginApi } from 'discourse/lib/plugin-api';

function extendHomeLogoUrl(api) {
    const siteSettings = api.container.lookup('site-settings:main');
    const categoryId = parseInt(siteSettings.home_category_id, 10);
    if (!isFinite(categoryId)) return;

    const categorySlug = siteSettings.home_category_slug;
    const href = `/c/${categorySlug}/${categoryId}`;
    api.changeWidgetSetting('home-logo', 'href', href);
}

export default {
    name: 'extend-home-logo-url',
    initialize: () => {
        withPluginApi('1.0.0', extendHomeLogoUrl);
    },
};
