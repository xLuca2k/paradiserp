const hud = new Vue({
    el: '.paradiserp',
    data: {
        url: `https://${GetParentResourceName()}`,
        user: {
            online: 25,
            uId: 1,
            ping: 99,
        },
    },

    mounted() {
        window.addEventListener("message", this.onMessage);
    },

    methods: {    
        async post(url, data = {}) {
            const response = await fetch(`${this.url}/${url}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            
            return await response.json();
        },
        onMessage(event) {
            const data = event.data;
            switch (data.action) {
                case 'updateHudStats':                    
                    this.user[data.what] = data.value;
                    break;
            }
        }
    }
});