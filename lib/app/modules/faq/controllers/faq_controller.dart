import 'package:get/get.dart';

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class FaqSection {
  final String title;
  final List<FaqItem> items;

  FaqSection({required this.title, required this.items});
}

class FaqController extends GetxController {
  final sections = <FaqSection>[
    FaqSection(
      title: 'GENERAL QUESTIONS',
      items: [
        FaqItem(
          question: 'What is GODEVI ?',
          answer:
              'At Godevi, we help you discover the best things to do in the tourism village in Indonesia. Find inspiration for your next travel adventure, from nature attractions to authentic local experiences. We empower the host from tourism village to guide you and get a lot of information about the village. we can offer you the best prices with the confidence of our world-class customer support. Join over one million happy travelers and go destination village.\n\nGODEVI is a tourism company under of PT Banua Wisata Lestari. GODEVI stands for Go Destination Village. The GODEVI logo is inspired by Bali Starling birds. Bali Starling is represented as one of the rare and unique natural potentials. The colors that appear in the GODEVI logo are cheerful colors that represent tourist activities full of joyful experiences. GODEVI believes that the village as a gathering place for all potentials, each has a different uniqueness and deserves to be introduced to the world community. Like this Bali Starling, GODEVI hopes to be able to become a distinctive brand without losing the identity of the island of Bali. In addition, the starling star is green, which means that GODEVI as a digital-based business is expected to be able to use its mind to see all the opportunities and phenomena that occur while being oriented to environmental sustainability and always prioritizing spirit of SEE (sustainability, empowerment, entrepreneurship)',
        ),
        FaqItem(
          question:
              'How I can trust the experiences and hosts? Does Godevi screen host?',
          answer:
              'We take guests’ security and the quality of experiences very seriously. At Godevi, We curate our experiences by pre-screening both our hosts and the experiences they offer. Also we provides training to the tourism village by meet them in person to train what the tourism village need and learn what they have to offer. So you will get the best experience with a trained host. You can get to know our hosts better by reading their bios on or checking out reviews left on the our website.',
        ),
        FaqItem(
          question:
              'Can you help me with creating an itinerary for my travel plan?',
          answer:
              'We are happy to recommend some of our many exisiting activities on the tourism village that may suit your plan. However, we are not able to help you with planning your itinerary.If you are interested in our tailor-made or customized tours, please visit our customized tour page.',
        ),
        FaqItem(
          question: 'What happens if something goes wrong the experience?',
          answer:
              'you encounter any issue with your booking and are unable to resolve it with your host, please contact us at hellogodevi@gmail.com within 12 hours of the start of the experience.\nTo protect you, Godevi collects your payment securely and holds on to your payment until 12 hours after the experience starts. If anything goes wrong, you can simply contact us without worrying that your host has already been paid.\nThe starting time is the time you requested when you made the booking.',
        ),
        FaqItem(
          question: 'How can I contact Godevi',
          answer:
              'You can message, call, and chat with us! View our contact page to get in touch with us',
        ),
      ],
    ),
    FaqSection(
      title: 'GODEVI SOCIAL RESPONSIBILITY',
      items: [
        FaqItem(
          question: 'What is important to Socially Responsible in Tourism?',
          answer:
              'GODEVI is a socially pro-active business dedicated to uplifting impoverished communities in the developing village through efforts in tourism industry. Beside also support fair trade, we create a marketplace by empowering the village communities. GODEVI adheres to a strict policy of promoting Socially Responsible Village Tourism activities. This can mean different things to different people, but here’s what it means to us:\n\n1. Collaborate with local village communities. This can be hard to find, but the GODEVI are always on the lookout for unique places that are run by locals, create jobs and are open to the idea of connecting more holistically into their communities. Our mission is Contribute to the local economy improvement.\n\n2. Commitment to the environment. For every our special guests that travels with us, we learn together about how to concern the environment, about how to save the planet.\n\n3. Preserving the local culture. GODEVI create the moment that you to experience the real people and culture of the destination you are visiting. This includes meals with local families, spending time in our partner villages, walking through local markets, meeting business owners, exploring religion and art, and connecting to people as individuals. We want you to never forget the people and places you encounter on a Authentic Village Experience journey..',
        ),
      ],
    ),
    FaqSection(
      title: 'BOOKING',
      items: [
        FaqItem(
          question:
              'How do I find out the availability and price of the activity?',
          answer:
              'On Godevi activity page, when you click "Book Now" you will be asked to confirm your order by filling in customer information and book information. On book information select the number of participants and check availability by clicking on the "Select Date" box. Available dates are in white and are clickable. You can see the total price on the right side at the bottom above "Book Now".',
        ),
        FaqItem(
          question: 'How do I make a booking on Godevi?',
          answer:
              'Go to the Godevi’s website at www.godestinationvillage.com. You can see and choose the activities and products we offer. When you click the "Book Now" button, you will be able to choose and book one or more of the activities or products we offer. After that, you will be asked to review your order and enter customer information regarding your personal data and book information. Fill in the correct, information requested then continue the order. You will get an email about ordering a package that you must to pay, you can click on the "order details" to continue filling out the complete information and proof of payment, you can pay via, bank transfer, visa or with PayPal. After you make a payment, please fill in the payment information by attaching the proof of payment. Please also note that the payment receipt is not a confirmation email. Our booking team will send an invoice to the email you specified after we received your order.',
        ),
        FaqItem(
          question: 'What is included in my booking?',
          answer:
              'You can view what is included and not included in your booking on the activity page. There you can see and look at descriptions of related activities, itinerary and important information regarding the activities.',
        ),
        FaqItem(
          question: 'Is the price per group or person?',
          answer:
              'Prices depend on the activity you choose, the activity page has been listed for the price per person. Please click "Book Now". You will see the difference by adding the number of participants. If the price details show a cheaper price, you add more participants, that means the price is group price. If the price multiplies, that means the price per person.',
        ),
        FaqItem(
          question: 'How do I know if my booking is confirmed?',
          answer:
              'If your booking request is received, you will receive an email confirmation with the full itinerary of your chosen activity, your host\'s contact information, and any records that the host has shared. For your convenience, Godevi holds your payment up to 12 hours after the experience begins, so if something goes wrong, you can contact us.',
        ),
        FaqItem(
          question: 'How long does it take to receive a confirmation?',
          answer:
              'When you order an activity and have made a payment by sending a confirmation form and proof of payment. This means that your request has been received automatically. After the Godevi booking team accepts your order, we will immediately confirm it. The host responds within a few hours, but has up to 72 hours or until your chosen date / time, which is faster, to respond before your request ends..',
        ),
        FaqItem(
          question: 'What is the status of my booking?',
          answer:
              'In Review: Your host is reviewing your order. The booking is waiting for their confirmation • Accepted: The booking has been approved. • Declined: The booking has been declined. Please check the message from the host on the "Dashboard" as the host may offer another available date for your chosen activity. • Expired: The booking expires automatically if the host is unable to accept or decline the order within 72 hours. Check your "Dashboard" for a message from the host. If your order is expired, please kindly wait until your host gets back to you as they are still working on it. If you are unable to wait, however, you are entitled to a full refund. • Cancelled: This would be your booking status after cancelling your order through the "Dashboard". Your experience is only officially cancelled when you receive an email from Godevi confirming the cancellation and your refund.',
        ),
        FaqItem(
          question: 'Can I amend / change my booking?',
          answer:
              'We completely understand that plans change. For most activities, it is possible to make changes to your booking. Please refer to the "Cancellation Policy" of your booking. If it is before the cancellation due date, please send a message to the host on your "Dashboard" by logging into Godevi\'s website. If the cancellation due date has passed, unfortunately you cannot change your booking. Can I book via phone? • Unfortunately, we do not accept bookings over the phone. Please proceed with your booking on Godevi\'s website.',
        ),
        FaqItem(
          question: 'How can I contact the host?',
          answer:
              'For general questions about an activity, you can send a message directly to an approved contact on the web via phone or massage. • Details about the host name, email address, and phone number will be shared when your order is received and requested by our booking team..',
        ),
      ],
    ),
    FaqSection(
      title: 'PAYMENT',
      items: [
        FaqItem(
          question: 'How can I pay for my booking?',
          answer:
              'You can pay securely using bank transfer, Mastercard, Amex, Visa, or Pay pal.',
        ),
        FaqItem(
          question: 'Can I pay by cash?',
          answer:
              'We accept cash on arrival, but you must pay a down payment of 30% of the total price.',
        ),
        FaqItem(
          question: 'When will my card be charged?',
          answer:
              'Your card will be charged once you have completed your booking. If your booking request is declined, you will receive a full refund.',
        ),
        FaqItem(
          question:
              'I am receiving an error code while trying to complete my booking and my credit card was rejected, what should I do?',
          answer:
              'You can send your question from the link provided when you find an error code to get help from the Godevi team. Contact us above of this page.',
        ),
        FaqItem(
          question: 'Are my credit card details safe?',
          answer:
              'Your payment details are fully secure. All data is encrypted and transmitted securely with an SSL protocol.',
        ),
        FaqItem(
          question: 'What is the Godevi service fee?',
          answer:
              'Our service fee is a fee for our team to handle your order. Our team contacts host villages, tour guides and partners to make your booking successful',
        ),
      ],
    ),
    FaqSection(
      title: 'CANCELLATIONS',
      items: [
        FaqItem(
          question: 'Can I cancel my booking and how do I do it?',
          answer:
              'We know that plans can change sometimes, and that’s why we’ve made it possible to cancel your booking if you really need to. Before canceling an experience, however, we suggest that you contact your host. They are very accommodating and might be able to adjust to your schedule if it’s simply a change of date or time. If you still need to cancel your booking, you can do so from your Dashboard. Go to Dashboard > Your Bookings to find all your upcoming experiences. Click through to the booking you want to cancel, and at the bottom, you’ll find a reminder of the experience’s cancellation policy and a button to cancel your booking.',
        ),
        FaqItem(
          question: 'Will I receive a refund after I cancel my booking?',
          answer:
              'The experience’s cancellation policy will determine whether or not you receive a full refund. You are entitled to a full refund under the following conditions: - Your booking is still in review - You cancel your booking before the cancellation due date.',
        ),
        FaqItem(
          question:
              'How long does it take to receive a refund in my bank account?',
          answer: 'The process usually takes 5-10 business days..',
        ),
        FaqItem(
          question: 'I didn\'t mean to cancel my booking, what should I do?',
          answer:
              'Please contact us immediately via dashboard message, email or phone, so we can change your status accordingly.',
        ),
        FaqItem(
          question: 'How do I know if my booking was cancelled ?',
          answer:
              'Your experience is only officially cancelled when you receive an email from us confirming the cancellation and your refund status..',
        ),
        FaqItem(
          question: 'What is Godevi\'s cancellation policy?',
          answer:
              'Each experience has its own cancellation policy, which you can view on the activity page. For information about the different policies hosts can choose from, please take a look at our Cancellation Policies..',
        ),
      ],
    ),
  ];
}
