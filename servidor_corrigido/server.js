let express;
let cors;

try {
  express = require('express');
  cors = require('cors');
} catch (error) {
  console.warn('Express/CORS nao encontrados. Usando servidor HTTP minimo de teste.');
  express = criarExpressMinimo;
  express.json = () => (_req, _res, next) => next && next();
  express.static = () => (_req, _res, next) => next && next();
  cors = () => (_req, _res, next) => next && next();
}

function criarExpressMinimo() {
  const http = require('http');
  const rotas = [];

  function app() {}

  app.use = () => {};

  app.get = (path, handler) => {
    rotas.push({ method: 'GET', path, handler });
  };

  app.post = (path, handler) => {
    rotas.push({ method: 'POST', path, handler });
  };

  app.listen = (port, host, callback) => {
    const server = http.createServer((req, res) => {
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

      if (req.method === 'OPTIONS') {
        res.writeHead(204);
        res.end();
        return;
      }

      const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
      const rota = rotas.find(
        (item) => item.method === req.method && item.path === url.pathname,
      );

      res.status = (code) => {
        res.statusCode = code;
        return res;
      };
      res.json = (body) => {
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(body));
      };
      res.type = (type) => {
        res.setHeader('Content-Type', `${type}; charset=utf-8`);
        return res;
      };
      res.send = (body) => {
        res.end(body);
      };

      if (!rota) {
        res.status(404).json({ erro: 'Rota nao encontrada' });
        return;
      }

      let raw = '';
      req.on('data', (chunk) => {
        raw += chunk;
      });
      req.on('end', () => {
        try {
          req.body = raw ? JSON.parse(raw) : {};
        } catch (error) {
          req.body = {};
        }
        rota.handler(req, res);
      });
    });

    return server.listen(port, host, callback);
  };

  return app;
}

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.static('public'));

const perfis_ace = [];
const pontos_estrategicos = [];
const visitas_pe = [];
const visitas_domiciliares = [];
const bti = [];
const ovitrampas = [];
const ovitrampa_checagens = [];
const coletas_larvarias = [];
const casos_dengue = [];
const esporotricose = [];
const quarteiroes = [];
const atividades_quarteirao = [];
const exclusoes_log = [];
const alertas_emergencia = [];
const localidades = [];
const setores_operacionais = [];
const quarteiroes_operacionais = [];
const atribuicoes_setor = [];
const progresso_quarteirao = [];
const auditoria_eventos = [];
const transportes_motoristas = [];
const transportes_veiculos = [];
const transportes_viagens = [];
const transportes_passageiros = [];
const pacientes = [];
const rastreamento_viagem = [];
const mapas_camadas = [];
const driver_events = [];
const driver_locations = [];
const driver_trips_status = [];
let ultimo_tubito = 0;
let driver_ultimo_recebimento = null;

function proximoId(lista) {
  if (!lista.length) return 1;
  return Math.max(...lista.map((item) => Number(item.id) || 0)) + 1;
}

function montarRegistro(lista, dados) {
  const agora = new Date();

  return {
    id: dados.id || proximoId(lista),
    municipio: dados.municipio || null,
    ace_responsavel: dados.ace_responsavel || dados.agente || null,
    latitude: dados.latitude ?? null,
    longitude: dados.longitude ?? null,
    data: dados.data || dados.data_visita || agora.toISOString().slice(0, 10),
    hora: dados.hora || agora.toTimeString().slice(0, 5),
    observacoes: dados.observacoes || null,
    status: dados.status || dados.situacao || null,
    foto_path: dados.foto_path || null,
    tipo: dados.tipo || null,
    origem: dados.origem || 'app_flutter',
    sincronizado_em: dados.sincronizado_em || agora.toISOString(),
    ...dados,
  };
}

function criarRotas(nome, lista) {
  app.get(`/api/${nome}`, (req, res) => {
    res.json(lista);
  });

  app.post(`/api/${nome}`, (req, res) => {
    const registro = montarRegistro(lista, req.body || {});
    lista.push(registro);

    res.status(201).json({
      sucesso: true,
      dados: registro,
    });
  });
}

function registrarDriver(lista, dados, tipoRegistro) {
  const recebidoEm = new Date().toISOString();
  driver_ultimo_recebimento = recebidoEm;

  const registro = {
    id: dados.id || `${tipoRegistro}-${Date.now()}-${lista.length + 1}`,
    received_at: recebidoEm,
    ...dados,
  };

  lista.push(registro);
  return registro;
}

function respostaDriver(lista) {
  return {
    total: lista.length,
    lastReceivedAt: driver_ultimo_recebimento,
    items: lista,
  };
}

function contarPorStatus(lista, status) {
  return lista.filter((item) => item.status === status).length;
}

function ehFocoPositivo(item) {
  return (
    item.foco_positivo === true ||
    item.foco_positivo === 1 ||
    item.focoPositivo === true ||
    item.resultado === 'Positiva' ||
    item.resultado === 'Positivo' ||
    item.status === 'Positiva' ||
    item.status === 'Positivo' ||
    item.status === 'Com foco'
  );
}

app.get('/api/status', (req, res) => {
  res.json({
    online: true,
    servidor: 'Plataforma Territorial Epidemiologica',
    modo: 'Servidor local',
    armazenamento: 'Memoria temporaria JSON',
    futuro_banco: 'PostgreSQL/Supabase',
    driver: {
      eventos: driver_events.length,
      localizacoes: driver_locations.length,
      status_viagens: driver_trips_status.length,
      ultimo_recebimento: driver_ultimo_recebimento,
    },
    data_hora: new Date().toISOString(),
  });
});

app.post('/api/driver/events', (req, res) => {
  const registro = registrarDriver(driver_events, req.body || {}, 'event');
  res.status(201).json({ sucesso: true, dados: registro });
});

app.get('/api/driver/events', (req, res) => {
  res.json(respostaDriver(driver_events));
});

app.post('/api/driver/locations', (req, res) => {
  const registro = registrarDriver(driver_locations, req.body || {}, 'location');
  res.status(201).json({ sucesso: true, dados: registro });
});

app.get('/api/driver/locations', (req, res) => {
  res.json(respostaDriver(driver_locations));
});

app.post('/api/driver/trips/status', (req, res) => {
  const registro = registrarDriver(
    driver_trips_status,
    req.body || {},
    'trip-status',
  );
  res.status(201).json({ sucesso: true, dados: registro });
});

app.get('/api/driver/trips/status', (req, res) => {
  res.json(respostaDriver(driver_trips_status));
});

app.get('/painel', (req, res) => {
  res.type('html').send(`<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Painel de Teste Driver App</title>
  <style>
    :root {
      color-scheme: light;
      font-family: Arial, sans-serif;
      color: #17202a;
      background: #f4f6f8;
    }
    body {
      margin: 0;
      padding: 24px;
    }
    header {
      display: flex;
      gap: 16px;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    h1 {
      margin: 0;
      font-size: 24px;
    }
    button {
      border: 0;
      border-radius: 6px;
      background: #1565c0;
      color: white;
      padding: 10px 14px;
      font-weight: 700;
      cursor: pointer;
    }
    main {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 16px;
    }
    section {
      background: white;
      border: 1px solid #dfe5ec;
      border-radius: 8px;
      padding: 16px;
      min-height: 180px;
    }
    h2 {
      margin: 0 0 12px;
      font-size: 18px;
    }
    .meta {
      color: #5f6f7d;
      font-size: 13px;
      margin-bottom: 10px;
    }
    pre {
      white-space: pre-wrap;
      word-break: break-word;
      background: #f8fafc;
      border: 1px solid #e1e7ef;
      border-radius: 6px;
      padding: 12px;
      max-height: 420px;
      overflow: auto;
    }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Painel de Teste Driver App</h1>
      <div class="meta" id="ultimo">Último recebimento: carregando...</div>
    </div>
    <button type="button" onclick="carregar()">Atualizar</button>
  </header>
  <main>
    <section>
      <h2>Eventos recebidos</h2>
      <div class="meta" id="eventos-meta"></div>
      <pre id="eventos">[]</pre>
    </section>
    <section>
      <h2>Localizações recebidas</h2>
      <div class="meta" id="localizacoes-meta"></div>
      <pre id="localizacoes">[]</pre>
    </section>
    <section>
      <h2>Status de viagens</h2>
      <div class="meta" id="status-meta"></div>
      <pre id="status">[]</pre>
    </section>
  </main>
  <script>
    async function carregarBloco(url, preId, metaId) {
      const resposta = await fetch(url);
      const dados = await resposta.json();
      document.getElementById(preId).textContent = JSON.stringify(dados.items, null, 2);
      document.getElementById(metaId).textContent = 'Total: ' + dados.total;
      return dados.lastReceivedAt;
    }

    async function carregar() {
      const ultimos = await Promise.all([
        carregarBloco('/api/driver/events', 'eventos', 'eventos-meta'),
        carregarBloco('/api/driver/locations', 'localizacoes', 'localizacoes-meta'),
        carregarBloco('/api/driver/trips/status', 'status', 'status-meta'),
      ]);
      const ultimo = ultimos.filter(Boolean).sort().pop();
      document.getElementById('ultimo').textContent =
        'Último recebimento: ' + (ultimo || 'nenhum dado recebido');
    }

    carregar();
  </script>
</body>
</html>`);
});

app.get('/api/dashboard', (req, res) => {
  const pesEmDia = contarPorStatus(pontos_estrategicos, 'Em dia');
  const pesVencendo = contarPorStatus(pontos_estrategicos, 'Vencendo');
  const pesAtrasados = contarPorStatus(pontos_estrategicos, 'Atrasado');
  const focosPositivos =
    visitas_pe.filter(ehFocoPositivo).length +
    visitas_domiciliares.filter(ehFocoPositivo).length +
    coletas_larvarias.filter(ehFocoPositivo).length +
    ovitrampa_checagens.filter(ehFocoPositivo).length;
  const ovitrampasPositivas =
    ovitrampas.filter(ehFocoPositivo).length +
    ovitrampa_checagens.filter(ehFocoPositivo).length;

  res.json({
    totalPEs: pontos_estrategicos.length,
    ativos: pesEmDia,
    vencendo: pesVencendo,
    atrasados: pesAtrasados,
    visitasPE: visitas_pe.length,
    visitasDomiciliares: visitas_domiciliares.length,
    aplicacoesBTI: bti.length,
    ovitrampasCadastradas: ovitrampas.length,
    ovitrampasPositivas,
    coletasLarvarias: coletas_larvarias.length,
    casosDengue: casos_dengue.length,
    casosEsporotricose: esporotricose.length,
    exclusoes: exclusoes_log.length,
    alertasEmergencia: alertas_emergencia.length,
    focosPositivos,
    pes_em_dia: pesEmDia,
    pes_vencendo: pesVencendo,
    pes_atrasados: pesAtrasados,
    total_visitas_pe: visitas_pe.length,
    visitas_domiciliares: visitas_domiciliares.length,
    focos_positivos: focosPositivos,
    aplicacoes_bti: bti.length,
    ovitrampas_cadastradas: ovitrampas.length,
    ovitrampas_positivas: ovitrampasPositivas,
    coletas_larvarias: coletas_larvarias.length,
    casos_dengue: casos_dengue.length,
    casos_esporotricose: esporotricose.length,
    exclusoes_log: exclusoes_log.length,
    alertas_emergencia: alertas_emergencia.length,
  });
});

app.get('/api/mapa/dados', (req, res) => {
  res.json({
    pes: pontos_estrategicos,
    bti,
    ovitrampas,
    coletas_larvarias,
    casos_dengue,
    esporotricose,
    quarteiroes,
    alertas_emergencia,
  });
});

app.get('/api/pes', (req, res) => {
  res.json(pontos_estrategicos);
});

app.post('/api/pes', (req, res) => {
  const registro = montarRegistro(pontos_estrategicos, req.body || {});
  pontos_estrategicos.push(registro);

  res.status(201).json({
    sucesso: true,
    dados: registro,
  });
});

app.get('/api/tubitos/status', (req, res) => {
  res.json({
    ultimo_tubito,
    proximo_tubito: ultimo_tubito + 1,
  });
});

app.post('/api/tubitos/reservar', (req, res) => {
  const quantidade = Math.max(0, Number(req.body?.quantidade) || 0);

  if (!quantidade) {
    return res.status(400).json({
      sucesso: false,
      erro: 'Informe a quantidade de tubitos.',
    });
  }

  const primeiro = ultimo_tubito + 1;
  const ultimo = ultimo_tubito + quantidade;
  ultimo_tubito = ultimo;

  res.status(201).json({
    sucesso: true,
    primeiro_numero: primeiro,
    ultimo_numero: ultimo,
    quantidade,
    municipio: req.body?.municipio || null,
    ace_responsavel: req.body?.ace_responsavel || req.body?.agente || null,
    sincronizado_em: new Date().toISOString(),
  });
});

criarRotas('perfis-ace', perfis_ace);
criarRotas('visitas-pe', visitas_pe);
criarRotas('visitas-domiciliares', visitas_domiciliares);
criarRotas('bti', bti);
criarRotas('ovitrampas', ovitrampas);
criarRotas('ovitrampas/checagens', ovitrampa_checagens);
criarRotas('coletas-larvarias', coletas_larvarias);
criarRotas('casos-dengue', casos_dengue);
criarRotas('esporotricose', esporotricose);
criarRotas('quarteiroes', quarteiroes);
criarRotas('atividades-quarteirao', atividades_quarteirao);
criarRotas('exclusoes-log', exclusoes_log);
criarRotas('alertas-emergencia', alertas_emergencia);
criarRotas('localidades', localidades);
criarRotas('setores-operacionais', setores_operacionais);
criarRotas('quarteiroes-operacionais', quarteiroes_operacionais);
criarRotas('atribuicoes-setor', atribuicoes_setor);
criarRotas('progresso-quarteirao', progresso_quarteirao);
criarRotas('auditoria-eventos', auditoria_eventos);
criarRotas('transportes/motoristas', transportes_motoristas);
criarRotas('transportes/veiculos', transportes_veiculos);
criarRotas('transportes/viagens', transportes_viagens);
criarRotas('transportes/passageiros', transportes_passageiros);
criarRotas('pacientes', pacientes);
criarRotas('rastreamento-viagem', rastreamento_viagem);
criarRotas('mapas/camadas', mapas_camadas);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor ACE Territorial rodando na porta ${PORT}`);
});
