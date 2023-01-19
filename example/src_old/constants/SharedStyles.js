
import { StyleSheet } from 'react-native';
import * as Colors  from './Colors';

export const sharedStyles = StyleSheet.create({
  itemTitle: {
    fontSize: 16,
    fontWeight: '600',
  },
  itemDescription: {
    fontSize: 16,
    fontWeight: '300',
    color: Colors.GREY[700]
  },
  buttonContainer: {
    padding: 10,
    alignSelf: 'stretch',
    alignItems: 'center',
  },
  button: {
    marginTop: 10,
    backgroundColor: Colors.BLUE.A700,
    paddingHorizontal: 15,
    paddingVertical: 10,
    borderRadius: 10,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '500',
  },
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'white',
    padding: 25,
    borderRadius: 15,
  },
  textEmoji: {
    fontSize: 64,
    marginBottom: 10,
  },
  textModal: {
    fontSize: 24,
    fontWeight: '800',
  },
  textModalContainer: {
    marginTop: 25,
    marginBottom: 10,
    backgroundColor: 'white',
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 10,
  },
  textModalSubtitle: {
  },
});