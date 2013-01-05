JSTP es un protocolo de comunicación serializado en JSON montado sobre websockets que utiliza por defecto el puerto 33333. 

El protocolo es simétrico: esto quiere decir que hay un solo tipo de mensajes. La acción de enviar un mensaje es un `dispatch`. Siendo que es basado en WebSockets, es también asincrónico, significando que los Dispatch no tienen porqué recibir respuesta. Para facilitar seguimiento de un hilo de comunicación, JSTP provee un encabezado `token` donde se sugiere ingresar un hash de control (similar al Etag de HTTP). El encabezado `token` es extensible a un array para contener varios tokens con distinta prioridad.

La estructura de cabeceras, métodos (acciones), nombres de recursos y cuerpo de mensaje está diseñada para ser completamente compatible con REST (implicando que se puede hacer _fallback_ a HTTP regular si es necesario). Las cabeceras no necesariamente incluyen todo los mismos datos que las de HTTP regular, pero es posible incluir la misma información. Una Dispatch de ejemplo sería:

    {
      "protocol": ["JSTP", "0.1"]
      "method": "POST", 
      "resource": [
        "session.manager",
        "User"
      ],
      "timestamp": 1357334118,
      "token": 3523902859084057289594,
      "referer": [
        "browser",
        "Registerer"
      ],
      "body": {
        "login": "xavier",
        "email": "xavier@fetcher.com",
        "password": "secret"
      }
    }

Un JSTP Dispatch es representable en forma abreviada similar en un HTTP Request. De esta manera, el ejemplo de arriba se puede presentar como:

    POST session.manager/User JSTP/0.1
    timestamp: 1357334118
    token: 3523902859084057289594
    referer: browser/Registerer
    
    login: xavier
    email: xavier@fetcher.com
    password: secret

Gateways
-------------

Todo servidor de JSTP conoce su host, que corresponde a la parte inicial del mensaje. Si el host del mensaje recibido no se corresponde con el 