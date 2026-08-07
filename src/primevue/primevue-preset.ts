import Aura from '@primevue/themes/aura';
import { definePreset } from '@primevue/themes';

export const primevuePreset = definePreset(Aura, {
    primitive: {
        navy: {
            50: '#E8E9F2',
            100: '#C5C8E3',
            200: '#9DA2D0',
            300: '#747CBD',
            400: '#3D4494',
            500: '#0a0d2e',
            600: '#080b26',
            700: '#06081d',
            800: '#040615',
            900: '#02030d'
        },
        gold: {
            50: '#FDF8EC',
            100: '#F9EDCA',
            200: '#F2DC98',
            300: '#E9C95F',
            400: '#C9A84C',
            500: '#A07828',
            600: '#7A5B1E',
            700: '#5A4015',
            800: '#3C280D',
            900: '#1E1406'
        },
        gray: {
            50: '#F7F7F7',
            100: '#EEEEEE',
            200: '#D5D5D5',
            300: '#BEBEBE',
            400: '#9E9E9E',
            500: '#7E7E7E',
            600: '#5F5F5F',
            700: '#424242',
            800: '#2E2E2E',
            900: '#1C1C1C'
        }
    },
    components: {
        togglebutton: {
            colorScheme: {
                light: {
                    content: {
                        checkedBackground: '#C9A84C',
                        checkedHoverBackground: '#A07828',
                        checkedColor: '#ffffff'
                    }
                }
            }
        },
        button: {
            colorScheme: {
                light: {
                    root: {
                        primary: {
                            background: '#0a0d2e',
                            hoverBackground: '#3D4494',
                            activeBackground: '#747CBD',
                            borderColor: '#0a0d2e',
                            hoverBorderColor: '#3D4494',
                            activeBorderColor: '#747CBD',
                            color: '#ffffff',
                            hoverColor: '#ffffff',
                            activeColor: '#ffffff'
                        },
                        secondary: {
                            background: '#C9A84C',
                            hoverBackground: '#A07828',
                            activeBackground: '#7A5B1E',
                            borderColor: '#C9A84C',
                            hoverBorderColor: '#A07828',
                            activeBorderColor: '#7A5B1E',
                            color: '#ffffff',
                            hoverColor: '#ffffff',
                            activeColor: '#ffffff'
                        }
                    },
                    outlined: {
                        primary: {
                            borderColor: '#0a0d2e30',
                            color: '#0a0d2e',
                            hoverBackground: 'rgba(10, 13, 46, 0.08)',
                            activeBackground: 'rgba(10, 13, 46, 0.16)'
                        },
                        secondary: {
                            borderColor: '#C9A84C80',
                            color: '#A07828',
                            hoverBackground: 'rgba(201, 168, 76, 0.08)',
                            activeBackground: 'rgba(201, 168, 76, 0.16)'
                        }
                    }
                }
            }
        }
    },
    semantic: {
        colorScheme: {
            light: {
                primary: {
                    color: '{navy.500}',
                    50: '{navy.50}',
                    100: '{navy.100}',
                    200: '{navy.200}',
                    300: '{navy.300}',
                    400: '{navy.400}',
                    500: '{navy.500}',
                    600: '{navy.600}',
                    700: '{navy.700}',
                    800: '{navy.800}',
                    900: '{navy.900}',
                    hover: { color: '{navy.400}' },
                    active: { color: '{navy.300}' }
                }
            },
            dark: {}
        }
    }
});
