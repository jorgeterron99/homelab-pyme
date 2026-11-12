# Registro de incidencias

Anota cada problema que te encuentres. Es documentación real y, en una entrevista, una de las mejores formas de demostrar criterio técnico.

## Plantilla
```
### INC-000 · Título breve
- Fecha:
- Fase:
- Síntoma:
- Diagnóstico (qué comprobé y en qué orden):
- Causa raíz:
- Solución:
- Prevención / lección aprendida:
```

## Incidencias

### INC-001 · (ejemplo) Los clientes no resuelven el dominio
- Fecha: 
- Fase: 3
- Síntoma: `cli-win01` no encuentra `pyme.lan` al unirse al dominio.
- Diagnóstico: `ipconfig /all` mostraba DNS 192.168.10.1; `nslookup pyme.lan` fallaba.
- Causa raíz: el DHCP seguía entregando fw01 como DNS.
- Solución: opción 006 del ámbito de dc01 con 192.168.20.10 y renovar con `ipconfig /renew`.
- Prevención: comprobar siempre DNS tras cambiar el servidor DHCP.
