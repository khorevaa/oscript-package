#Использовать configor
#Использовать logos
#Использовать json
#Использовать "./internal"

Перем Имя Экспорт; // Строка
Перем Версия Экспорт; // Строка
Перем Описание Экспорт; // Строка

Перем ВерсияСреды Экспорт; // Строка
Перем ИсполняемаяСреда Экспорт; // Структура (oscript, mono)
Перем Лицензия Экспорт; // Строка

Перем ДомашняяСтраница Экспорт; // Строка
Перем Репозиторий Экспорт; // Строка
Перем ТрекерОшибок Экспорт; // Строка
Перем ТочкаВхода Экспорт; // Строка

Перем ВключаемыеФайлы Экспорт; // Массив
Перем ОбъявлениеМодулей Экспорт; // Структура ключи Классы, Модули, значения Соответствие 

Перем КлючевыеСлова Экспорт; // Массив
Перем Зависимости Экспорт; // Соответствие Ключ - имя библиотеки, значение версия
Перем ЗависимостиРазработки Экспорт; // Соответствие Ключ - имя библиотеки, значение версия

Перем Автор Экспорт; // Структура Ключи  Имя, ПочтовыйАдрес, ИнтернетСтраница 
Перем Разработчики Экспорт; // Массив из Структура Ключи  Имя, ПочтовыйАдрес, ИнтернетСтраница 

Перем Задачи Экспорт; // Соответствие Ключ - имя задачи, значение - текст исполнения
Перем ИсполняемыеФайлы Экспорт; // Соответствие Ключ - имя исполняемого файла, значение путь к файлу

Перем Лог;

Функция ПрочитатьФайлОписанияПакета(Знач ПутьКФайлуОписания) Экспорт

	ФайлОписания = Новый Файл(ПутьКФайлуОписания);
	РасширениеФайлаОписания = ФайлОписания.Расширение;
	
	КонструкторОписанияПакета = Новый КонструкторОписанияПакета;

	Лог.Отладка("Читаю файл <%1>", ПутьКФайлуОписания);

	Если ПустаяСтрока(РасширениеФайлаОписания) Тогда
	
		ОписаниеПакетаOS = ПрочитатьМанифест(ПутьКФайлуОписания);
		ПреобразоватьОписаниеПакета(ОписаниеПакетаOS, КонструкторОписанияПакета);	

	Иначе
	
		МенеджерПараметров = Новый МенеджерПараметров;
		
		МенеджерПараметров.ИспользоватьПровайдерJSON();
		МенеджерПараметров.ИспользоватьПровайдерYAML();
		МенеджерПараметров.УстановитьФайлПараметров(ПутьКФайлуОписания);
		МенеджерПараметров.КонструкторПараметров(КонструкторОписанияПакета);
		МенеджерПараметров.Прочитать();
	
	КонецЕсли;
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КонструкторОписанияПакета.Параметры());

КонецФункции

Функция ПрочитатьМанифест(Знач ФайлМанифеста)

	ОписаниеПакета = Новый ОписаниеПакетаOS();
	ВнешнийКонтекст = Новый Структура("Описание", ОписаниеПакета);
	ОбработчикСобытий = ЗагрузитьСценарий(ФайлМанифеста, ВнешнийКонтекст);

	Возврат ОписаниеПакета;

КонецФункции

Процедура ПреобразоватьОписаниеПакета(ОписаниеПакета, КонструкторОписанияПакета) Экспорт
	
	СвойстваПакета = ОписаниеПакета.Свойства();

	Результат = Новый Соответствие();
	Результат.Вставить("Имя", СвойстваПакета.Имя);
	Результат.Вставить("Версия", СвойстваПакета.Версия);
	Результат.Вставить("Описание", СвойстваПакета.Описание);
	
	СоответствиеАвтора = Новый Соответствие();
	СоответствиеАвтора.Вставить("Имя", СвойстваПакета.Автор);
	СоответствиеАвтора.Вставить("Емайл", СвойстваПакета.АдресАвтора);
	
	Результат.Вставить("Автор", СоответствиеАвтора);

	Если СвойстваПакета.Свойство("ВерсияСреды") Тогда
		Результат.Вставить("ВерсияСреды", СвойстваПакета.ВерсияСреды);
	КонецЕсли;
	Если СвойстваПакета.Свойство("ТочкаВхода") Тогда
		Результат.Вставить("ТочкаВхода", СвойстваПакета.ТочкаВхода);
	КонецЕсли;
	
	Результат.Вставить("ВключаемыеФайлы", ОписаниеПакета.ВключаемыеФайлы());
	
	ТаблицаИсполняемыеФайлы = ОписаниеПакета.ИсполняемыеФайлы();

	СоответствиеИсполняемыеФайлы = Новый Соответствие();

	Для каждого СтрокаТаблицы Из ТаблицаИсполняемыеФайлы Цикл

		ИмяПриложения = СтрокаТаблицы.ИмяПриложения;

		Если ПустаяСтрока(ИмяПриложения) Тогда
			ИмяПриложения = Имя;
		КонецЕсли;

		СоответствиеИсполняемыеФайлы.Вставить(ИмяПриложения, СтрокаТаблицы.Путь);

	КонецЦикла;
	Результат.Вставить("ИсполняемыеФайлы", СоответствиеИсполняемыеФайлы);

	СоответствиеЗависимости = Новый Соответствие();
	ТаблицаЗависимости = ОписаниеПакета.Зависимости();
	Для каждого СтрокаТаблицы Из ТаблицаЗависимости Цикл

		СоответствиеЗависимости.Вставить(СтрокаТаблицы.ИмяПакета, СтрокаТаблицы.МинимальнаяВерсия);

	КонецЦикла;
	
	Результат.Вставить("Зависимости", СоответствиеЗависимости);

	
	СоответсвиеКлассов = ПолучитьСоответствиеМодулей(ОписаниеПакета.Классы());
	СоответсвиеМодулей = ПолучитьСоответствиеМодулей(ОписаниеПакета.Модули());

	СоответствиеОбъявлениеМодулей = Новый Соответствие();
	СоответствиеОбъявлениеМодулей.Вставить("Классы", СоответсвиеКлассов);
	СоответствиеОбъявлениеМодулей.Вставить("ОбъявлениеМодулей", СоответсвиеМодулей);

	Результат.Вставить("ОбъявлениеМодулей", СоответствиеОбъявлениеМодулей);

	КонструкторПараметров = Новый КонструкторПараметров();
	КонструкторОписанияПакета.ОписаниеПараметров(КонструкторПараметров);

	КонструкторПараметров.ИзСоответствия(Результат);
	КонструкторОписанияПакета.УстановитьПараметры(КонструкторПараметров.ВСтруктуру());

КонецПроцедуры

Функция ПолучитьСоответствиеМодулей(ТаблицаМодулей)

	Результат = Новый Соответствие();

	Для каждого СтрокаТаблицы Из ТаблицаМодулей Цикл

		Результат.Вставить(СтрокаТаблицы.Идентификатор, СтрокаТаблицы.Файл);

	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Процедура Сериализовать(ЧтениеФайла, ФорматСериализации = "json")

	Если ФорматСериализации = "json" Тогда
	
		
	ИначеЕсли ФорматСериализации = "xml" Тогда
		// TODO: Сделать сериализацию
	Иначе
		Лог.Ошибка("Не известный формат сериализации <%1>", ФорматСериализации);
	КонецЕсли;

	
КонецПроцедуры

Функция СоответствиеСПравильнымиИменами()
	
	КонструкторОписанияПакета = Новый КонструкторОписанияПакета;
	ИменаДляЗаписи = КонструкторОписанияПакета.СоответствиеИменСвойствДляЗаписи();

	СоответствиеСериализации = Новый Соответствие();
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Имя"], Имя);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Версия"], Версия);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Описание"], Описание);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ВерсияСреды"], ВерсияСреды);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ИсполняемаяСреда"], ОбработатьЭлементСоответствия(ИсполняемаяСреда, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ДомашняяСтраница"], ДомашняяСтраница);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Репозиторий"], ОбработатьЭлементСоответствия(Репозиторий, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ТрекерОшибок"], ТрекерОшибок);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ТочкаВхода"], ТочкаВхода);
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ВключаемыеФайлы"], ОбработатьЭлементСоответствия(ВключаемыеФайлы, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ОбъявлениеМодулей"], ОбработатьЭлементСоответствия(ОбъявлениеМодулей, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["КлючевыеСлова"], ОбработатьЭлементСоответствия(КлючевыеСлова, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Зависимости"], ОбработатьЭлементСоответствия(Зависимости, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ЗависимостиРазработки"], ОбработатьЭлементСоответствия(ЗависимостиРазработки, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Автор"], ОбработатьЭлементСоответствия(Автор, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Разработчики"], ОбработатьЭлементСоответствия(Разработчики, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["Задачи"], ОбработатьЭлементСоответствия(Задачи, ИменаДляЗаписи));
	СоответствиеСериализации.Вставить(ИменаДляЗаписи["ИсполняемыеФайлы"], ОбработатьЭлементСоответствия(ИсполняемыеФайлы, ИменаДляЗаписи));

	Возврат СоответствиеСериализации;

КонецФункции

Функция ОбработатьЭлементСоответствия(ЭлементСоответствия, ИменаДляЗаписи)
	
	Если ТипЗнч(ЭлементСоответствия) = Тип("Соответствие") 
		ИЛИ ТипЗнч(ЭлементСоответствия) = Тип("Структура") Тогда
		
		НовоеСоотвествие = Новый Соответствие();

		Для каждого КлючЗначение Из ЭлементСоответствия Цикл
			
			НовоеСоотвествие.Вставить(ИмяКлючаСоответствия(КлючЗначение, ИменаДляЗаписи),
									 ОбработатьЭлементСоответствия(КлючЗначение.Значение, ИменаДляЗаписи));

		КонецЦикла;

		Возврат НовоеСоотвествие;

	ИначеЕсли ТипЗнч(ЭлементСоответствия) = Тип("Массив") Тогда

		НовыйМассив = Новый Массив();

		Для каждого ЭлементМассив Из ЭлементСоответствия Цикл
			
			НовыйМассив.Добавить(ОбработатьЭлементСоответствия(ЭлементМассив, ИменаДляЗаписи));

		КонецЦикла;

		Возврат НовыйМассив;

	Иначе
		Возврат ЭлементСоответствия;
	
	КонецЕсли;

КонецФункции

Функция ИмяКлючаСоответствия(Знач Ключ, ИменаДляЗаписи)

	ИмяКлюча = ИменаДляЗаписи.Получить(Ключ);

	Если ИмяКлюча = Неопределено Тогда
		Возврат Ключ;
	КонецЕсли;
	
	Возврат ИмяКлюча;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.packagedef");
Лог.УстановитьУровень(УровниЛога.Отладка);
Лог2 = Логирование.ПолучитьЛог("oscript.lib.configor.constructor");
Лог2.УстановитьУровень(УровниЛога.Отладка);
