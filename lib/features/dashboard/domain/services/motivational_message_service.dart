// lib/features/dashboard/domain/services/motivational_message_service.dart
//
// Orynta 2.0 — Curated Motivational Quote Service (100+ Curated Quotes)

import 'dart:math';
import '../models/motivation_message.dart';

class MotivationalMessageService {
  const MotivationalMessageService();

  static const List<MotivationMessage> _quotes = [
    MotivationMessage(id: 'q1', message: 'Discipline is choosing what you want most over what you want now.'),
    MotivationMessage(id: 'q2', message: 'Small progress every day creates remarkable results.'),
    MotivationMessage(id: 'q3', message: 'Consistency beats intensity. Keep showing up.'),
    MotivationMessage(id: 'q4', message: 'Focus on one task at a time. Protect your attention.'),
    MotivationMessage(id: 'q5', message: 'Focus on progress, not perfection.'),
    MotivationMessage(id: 'q6', message: 'Great things are done by a series of small things.'),
    MotivationMessage(id: 'q7', message: 'Your future self will thank you for today.'),
    MotivationMessage(id: 'q8', message: 'It is not that we have a short time to live, but that we waste a lot of it.'),
    MotivationMessage(id: 'q9', message: 'Clarity precedes success. Define your next action.'),
    MotivationMessage(id: 'q10', message: 'Build momentum with single-tasking.'),
    MotivationMessage(id: 'q11', message: 'You do not rise to the level of your goals. You fall to the level of your systems.'),
    MotivationMessage(id: 'q12', message: 'Make today count. Effort is never wasted.'),
    MotivationMessage(id: 'q13', message: 'Quiet focus unlocks deep work.'),
    MotivationMessage(id: 'q14', message: 'Small wins add up quickly.'),
    MotivationMessage(id: 'q15', message: 'Stay curious, persistent, and calm.'),
    MotivationMessage(id: 'q16', message: 'Master the present moment.'),
    MotivationMessage(id: 'q17', message: 'Simple steps lead to grand achievements.'),
    MotivationMessage(id: 'q18', message: 'Protect your focus and energy.'),
    MotivationMessage(id: 'q19', message: 'Consistency turns effort into excellence.'),
    MotivationMessage(id: 'q20', message: 'Organize your mind, elevate your work.'),
    MotivationMessage(id: 'q21', message: 'Amor Fati: Love your fate, which is in fact your life.'),
    MotivationMessage(id: 'q22', message: 'Simplicity is the ultimate sophistication.'),
    MotivationMessage(id: 'q23', message: 'Focus is a matter of deciding what things you are not going to do.'),
    MotivationMessage(id: 'q24', message: 'The best way to predict the future is to create it.'),
    MotivationMessage(id: 'q25', message: 'Deep work is the ability to focus without distraction on demanding tasks.'),
    MotivationMessage(id: 'q26', message: 'The secret of getting ahead is getting started.'),
    MotivationMessage(id: 'q27', message: 'A year from now you may wish you had started today.'),
    MotivationMessage(id: 'q28', message: 'Act as if what you do makes a difference. It does.'),
    MotivationMessage(id: 'q29', message: 'Do what you can, with what you have, where you are.'),
    MotivationMessage(id: 'q30', message: 'Either you run the day, or the day runs you.'),
    MotivationMessage(id: 'q31', message: 'He who has a why to live can bear almost any how.'),
    MotivationMessage(id: 'q32', message: 'Do not watch the clock; do what it does. Keep going.'),
    MotivationMessage(id: 'q33', message: 'If you spend too much time thinking about a thing, you will never get it done.'),
    MotivationMessage(id: 'q34', message: 'Only those who risk going too far can possibly find out how far one can go.'),
    MotivationMessage(id: 'q35', message: 'The successful warrior is the average man, with laser-like focus.'),
    MotivationMessage(id: 'q36', message: 'It always seems impossible until it is done.'),
    MotivationMessage(id: 'q37', message: 'Quality is not an act, it is a habit.'),
    MotivationMessage(id: 'q38', message: 'It is during our darkest moments that we must focus to see the light.'),
    MotivationMessage(id: 'q39', message: 'Knowing is not enough; we must apply. Willing is not enough; we must do.'),
    MotivationMessage(id: 'q40', message: 'The only limit to our realization of tomorrow will be our doubts of today.'),
    MotivationMessage(id: 'q41', message: 'You miss 100% of the shots you do not take.'),
    MotivationMessage(id: 'q42', message: 'Action is the foundational key to all success.'),
    MotivationMessage(id: 'q43', message: 'There is no traffic jam along the extra mile.'),
    MotivationMessage(id: 'q44', message: 'You must do the things you think you cannot do.'),
    MotivationMessage(id: 'q45', message: 'Be not afraid of going slowly, be afraid only of standing still.'),
    MotivationMessage(id: 'q46', message: 'The start is what stops most people.'),
    MotivationMessage(id: 'q47', message: 'What we fear doing most is usually what we most need to do.'),
    MotivationMessage(id: 'q48', message: 'Do not wish it were easier. Wish you were better.'),
    MotivationMessage(id: 'q49', message: 'Focus on being productive instead of busy.'),
    MotivationMessage(id: 'q50', message: 'The key is not to prioritize what is on your schedule, but to schedule your priorities.'),
    MotivationMessage(id: 'q51', message: 'Ordinary people think merely of spending time. Great people think of using it.'),
    MotivationMessage(id: 'q52', message: 'Your mind is for having ideas, not holding them.'),
    MotivationMessage(id: 'q53', message: 'If you do not design your own life plan, chances are you will fall into someone else\'s.'),
    MotivationMessage(id: 'q54', message: 'Tomorrow is often the busiest day of the week.'),
    MotivationMessage(id: 'q55', message: 'Concentrate all your thoughts upon the work at hand. The sun\'s rays do not burn until brought to a focus.'),
    MotivationMessage(id: 'q56', message: 'You can do anything, but not everything.'),
    MotivationMessage(id: 'q57', message: 'Until we can manage time, we can manage nothing else.'),
    MotivationMessage(id: 'q58', message: 'Great work is done by people who are not afraid to be great.'),
    MotivationMessage(id: 'q59', message: 'The critical ingredient is getting off your butt and doing something.'),
    MotivationMessage(id: 'q60', message: 'Success is the sum of small efforts, repeated day in and day out.'),
    MotivationMessage(id: 'q61', message: 'Nothing will work unless you do.'),
    MotivationMessage(id: 'q62', message: 'Well begun is half done.'),
    MotivationMessage(id: 'q63', message: 'A goal without a timeline is just a dream.'),
    MotivationMessage(id: 'q64', message: 'Live life as if everything is rigged in your favor.'),
    MotivationMessage(id: 'q65', message: 'It is the working man who is the happy man. It is the idle man who is the miserable man.'),
    MotivationMessage(id: 'q66', message: 'Do not wait. The time will never be just right.'),
    MotivationMessage(id: 'q67', message: 'A calendar is better than a to-do list because it forces you to face the limits of time.'),
    MotivationMessage(id: 'q68', message: 'Productivity is being able to do things that you were never able to do before.'),
    MotivationMessage(id: 'q69', message: 'Efficiency is doing things right; effectiveness is doing the right things.'),
    MotivationMessage(id: 'q70', message: 'Make each day your masterpiece.'),
    MotivationMessage(id: 'q71', message: 'If you want to make an easy job seem mighty hard, just keep putting off doing it.'),
    MotivationMessage(id: 'q72', message: 'To think is easy. To act is difficult. To act as one thinks is the most difficult thing.'),
    MotivationMessage(id: 'q73', message: 'The absolute best way to finish a task is to start it.'),
    MotivationMessage(id: 'q74', message: 'Start where you are. Use what you have. Do what you can.'),
    MotivationMessage(id: 'q75', message: 'How you do anything is how you do everything. Pay attention to details.'),
    MotivationMessage(id: 'q76', message: 'One key to success is to have lunch at the time of day most people are having breakfast.'),
    MotivationMessage(id: 'q77', message: 'Never put off till tomorrow what you can do today.'),
    MotivationMessage(id: 'q78', message: 'Do not make excuses, make improvements.'),
    MotivationMessage(id: 'q79', message: 'Patience and perseverance have a magical effect before which difficulties disappear.'),
    MotivationMessage(id: 'q80', message: 'You are what you repeatedly do. Excellence, then, is not an act, but a habit.'),
    MotivationMessage(id: 'q81', message: 'There is nothing so useless as doing efficiently that which should not be done at all.'),
    MotivationMessage(id: 'q82', message: 'Your energy flows where your attention goes.'),
    MotivationMessage(id: 'q83', message: 'The true price of anything is the amount of life you exchange for it.'),
    MotivationMessage(id: 'q84', message: 'You have power over your mind - not outside events. Realize this, and you will find strength.'),
    MotivationMessage(id: 'q85', message: 'The more you sweat in peace, the less you bleed in war.'),
    MotivationMessage(id: 'q86', message: 'If you do not standardise, you cannot improve.'),
    MotivationMessage(id: 'q87', message: 'If you have to eat a frog, do it first thing in the morning.'),
    MotivationMessage(id: 'q88', message: 'Energy is the essence of life. Focus is the guide.'),
    MotivationMessage(id: 'q89', message: 'Strive not to be a success, but rather to be of value.'),
    MotivationMessage(id: 'q90', message: 'The path to success is to take massive, determined action.'),
    MotivationMessage(id: 'q91', message: 'You cannot change your destination overnight, but you can change your direction.'),
    MotivationMessage(id: 'q92', message: 'Little strokes fell great oaks.'),
    MotivationMessage(id: 'q93', message: 'Perfect is the enemy of good.'),
    MotivationMessage(id: 'q94', message: 'Simplify, then add lightness.'),
    MotivationMessage(id: 'q95', message: 'Slow is smooth, and smooth is fast.'),
    MotivationMessage(id: 'q96', message: 'The shorter the timeline, the clearer the focus.'),
    MotivationMessage(id: 'q97', message: 'Create space for what matters, say no to the rest.'),
    MotivationMessage(id: 'q98', message: 'A plan is only as good as its execution.'),
    MotivationMessage(id: 'q99', message: 'First forget inspiration. Habit is more dependable.'),
    MotivationMessage(id: 'q100', message: 'An hour of planning can save you hours of doing.'),
    MotivationMessage(id: 'q101', message: 'Focus is not about saying yes, it is about saying no to a hundred other good ideas.'),
    MotivationMessage(id: 'q102', message: 'The best productivity tool is a clear mind.'),
    MotivationMessage(id: 'q103', message: 'Quiet the noise, enhance the signal.'),
    MotivationMessage(id: 'q104', message: 'One day at a time, one block at a time.'),
    MotivationMessage(id: 'q105', message: 'Begin, begin, be bold, and venture to be wise.'),
  ];

  /// Returns quote seeded by the current day of year (remains stable all day).
  MotivationMessage getDailyQuote([DateTime? time]) {
    final date = time ?? DateTime.now();
    final seed = date.year * 1000 + date.ordinalDay;
    final index = Random(seed).nextInt(_quotes.length);
    return _quotes[index];
  }
}

extension _OrdinalDayExtension on DateTime {
  int get ordinalDay {
    final firstDay = DateTime(year, 1, 1);
    return difference(firstDay).inDays + 1;
  }
}
