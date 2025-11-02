# مقدمة
 السباق على الموارد في أنظمة التشغيل يقصد به محاولة أكثر من عمليةٍ الحصول على مورد ما (بيانات أو وقت معالجة) و يكون المورد محدودًا.
في بعض الحالات قد يكون هنالك عمليتين يحتاج كل منهم مورد موجود مع الأخرى ولا يستطيع أي منهما إنهاء عمله إلا بذلك المورد ، في هذه الحالة يحصل ما يعرف بالاختناق/بالتعنت المتبادل (Deadlock).
في سنة 1965 وضع ديكسترا مثالًا توضيحيًا لهذه الفكرة وهو عشاء الفلاسفة.
يقول المثال :
تخيل وجود عدد من الفلاسفة يجلسون على طاولة دائرية و أمام كلٍ منهم صحنّ و شوكة ، كل فيلسوف يفكر ما شاء إلى أن يجوع ، فإذا جائع احتاج شوكتين لكي يأكل من الصحن الذي أمامه ، ولكن لا يستطيع أي فيلسوف طلب شوكة أخذها غيره ، ولا يستطيع أي منهم الأكل إلا بشوكتين التي أمامه و التي في يساره أو يمينه ، في حال شبع الفيلسوف يعيد الشوكة فيستطيع غيره أخذها و أن يأكل بها .

مشروعي في مادة نظم التشغيل كان تمثيل عشاء الفلاسفة باستخدام فلاتر(Flutter) ، مع وضع أشهر الحلول لهذه المشكلة.

# الخورزميات
1. ألتقاط المتاح :و هذا هو الأصل و لكنه قد يسبب اختناق لذا وضعت الخورزميات الأخرى لحله
2. أيدا باليسار : أن تبدأ بالشوكة التي في يسار الفيلسوف دائًما مما يظمن أن الاختناق لن يتم مهما حصل ؛ لأن الفيلسوف الأخير سيجد أن الشوكة التي في يسارة مشغولة ولن يحجز الشوكة التي في يمينه
3. أبدا باليمين : أن تبدأ بالشوكة التي في يمين الفيلسوف دائًما مما يظمن أن الاختناق لن يتم مهما حصل ؛ لأن الفيلسوف الأخير سيجد أن الشوكة التي في يسارة مشغولة ولن يحجز الشوكة التي في يساره
4. تقييد عدد الفلاسفة : بأن تضمن ان عدد الشوك يزيد دائمًا عن عدد الفلاسفة بواحد على الأقل .
5. التحقق المزدوج : بأن يتأكد من أن كل الشوكتين متاحتان قبل أن يلتقط أي منهما .
6. الزوجين يبدأون باليمين و الفريدين يبدأون باليسار

# Introduction
Resource contention in operating systems refers to the situation where multiple processes attempt to access a shared and limited resource (such as data or processing time).
In some cases, two processes may each hold a resource the other needs and cannot proceed without obtaining it. This situation leads to what is known as a deadlock.
In 1965, Edsger Dijkstra introduced a famous example to illustrate this concept — the Dining Philosophers Problem.
The example goes as follows:
Imagine several philosophers sitting around a circular table. In front of each philosopher is a plate and a fork. Each philosopher thinks for a while until they get hungry. When hungry, a philosopher needs two forks to eat from the plate in front of them. However, no philosopher can take a fork that is already being used by another, and none can eat unless they hold both the fork in front of them and the one to their left (or right). When a philosopher finishes eating, they return both forks so others can use them.
My project for the Operating Systems course was to simulate the Dining Philosophers Problem using Flutter, while implementing and demonstrating the most common solutions to this problem.

# Algorithms
1. Pick the available: This is the default approach, but it can lead to deadlock, hence the introduction of the following solutions.
2. Always pick the left fork first: Each philosopher always starts by picking the fork on their left. This ensures that deadlock will never occur because the last philosopher will find the left fork unavailable and will not block others by holding the right one.
3. Always pick the right fork first: Each philosopher always starts by picking the fork on their right. This also guarantees no deadlock for the same reasoning as above.
4. Limit the number of philosophers: Ensure that the number of forks is always at least one greater than the number of philosophers.
5. Double check: A philosopher checks that both forks are available before attempting to pick up either one.
6. Even and odd strategy: Philosophers with even numbers start by picking the right fork, while those with odd numbers start with the left.



<img width="1920" height="1081" alt="image" src="https://github.com/user-attachments/assets/4140dd94-2e1f-4b79-9788-8f26975b3aec" />

