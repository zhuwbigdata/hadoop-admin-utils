use bible;
-- print verses given chapter index and book partition
select verse from orc_part1_book where cidx = 3  and  book = 'Jn';
-- print single verse given chapter index, verse index and book partition
select verse from orc_part1_book where cidx = 3 and vidx = 16 and  book = 'Jn';
-- print number of chapters given book partition
select count(distinct(cidx)) from orc_part1_book where book = 'Jn';
-- print number of chapters given book partition
select cidx, count(vidx) from orc_part1_book where book = 'Jn' group by cidx;
-- print  number of verses given book partition
select count(distinct cidx, vidx) from orc_part1_book where book = 'Jn';
-- print  number of verses given book partition
select count(vidx) from orc_part1_book where book = 'Jn';
!quit
