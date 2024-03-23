import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
  IonText,
  IonItem,
  IonButton,
  IonLabel,
  IonInput,
} from "@ionic/react";
import { ErrorMessage } from "@hookform/error-message";
import {
  useForm,
  Controller,
  SubmitHandler,
  FieldValues,
} from "react-hook-form";

interface FormData {
  password: string;
}

const UnlockPage: React.FC = () => {
  const {
    control,
    handleSubmit,
    register,
    formState: { errors },
  } = useForm();

  const onSubmit: SubmitHandler<FieldValues> = (data) => {
    console.log("testando submit");
    console.log(data);
  };

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Desbloquear Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Desbloquear Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <form onSubmit={handleSubmit(onSubmit)}>
          <IonItem>
            <IonInput
              label="Insira sua Senha"
              labelPlacement="floating"
              color={errors.senha ? "danger" : ""}
              type="password"
              {...register("senha", {
                required: "Insira uma senha!",
                pattern: {
                  value: /^[\x20-\x7E]{10}$/,
                  message: "A senha deve ter exatamente 10 caracteres ASCII",
                },
              })}
            />
          </IonItem>
          <ErrorMessage
            errors={errors}
            name="senha"
            as={<div style={{ color: "red" }} />}
          />
          <div>
            <IonButton
              onClick={() => console.log(errors)}
              className="ion-margin-top"
              type="submit"
            >
              Desbloquear
            </IonButton>
          </div>
        </form>
      </IonContent>
    </IonPage>
  );
};

export default UnlockPage;
