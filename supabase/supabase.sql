/* tabela de logs */
create table
  public.logs (
    id bigint generated by default as identity,
    message character varying not null,
    topic character varying null,
    date timestamp with time zone null default now(),
    type text null,
    constraint logs_pkey primary key (id)
  ) tablespace pg_default;

/* View consultada pelo app para gerar as estatísticas de utilização*/
create view
  public.log_stats as
select
  logs.type,
  count(*) as type_count
from
  logs
where
  logs.date >= (current_timestamp - '24:00:00'::interval)
group by
  logs.type;
