create view nextinbound(id) as (
	select i.id
	from inbound as i
	where i.toload = True
	order by i.arrival
	limit 1
);

create view nextinbounditems(id) as (
	select u.package
	from upload as u join nextinbound as ni on (ni.id = u.inbound)
);

create view availablepack(aic,id,expire) as (
	select d.code,p.id,p.expire
	from package as p join drug as d on (d.id = p.drug)
	where p.state = 'loaded'
);

create view to_upload(bid,did) as (
	select i.id,i.document_id
	from inbound as i 
	where i.upload is null
);

create view to_download(id,email,department,arrivedate) as (
	select o.id, u.email, d.description, o.download
	from outbound as o join dbuser as u on (o.dbuser = u.id) join department as d on (d.id = u.dept)
	where o.ready is null
);

create view availableCloset(closet) as (
	select ox.id
	from outbox as ox
	where ox.id not in (
		select ot.outbox
		from outbound as ot
		where ot.withdrawal is null
	) and ox.id <> 'NULL'
);

