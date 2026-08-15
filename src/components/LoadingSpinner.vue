<template>
    <div class="spinner" />
</template>

<style scoped>
.spinner {
    width: 36px;
    height: 36px;
    border: 3px solid #D5D5D5;
    border-top-color: var(--primary-color);
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}
</style>
